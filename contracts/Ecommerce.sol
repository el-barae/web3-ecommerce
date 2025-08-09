pragma solidity ^0.8.0;

contract Ecommerce {
    struct Commodity {
        string name;
        string category;
        uint256 value;
        uint256 quantity;
        string company;
        address seller;
    }

    struct User {
        string firstName;
        string lastName;
        uint256 age;
        string gender;
        bool isSeller;
        string email;
        uint256 balance;
    }


    mapping(address => User) public users;
    Commodity[] public commodities;

    function register(
        string memory _firstName,
        string memory _lastName,
        uint256 _age,
        string memory _gender,
        bool _isSeller,
        string memory _email
    ) public {
        users[msg.sender] = User(_firstName, _lastName, _age, _gender, _isSeller, _email, 0);
    }

    function deposit() public payable {
        require(msg.value > 0, "Montant invalide");
        users[msg.sender].balance += msg.value;
    }


    // Add a new commodity to the marketplace
    function addCommodity(
        string memory _name,
        string memory _category,
        uint256 _value,
        uint256 _quantity,
        string memory _company
    ) public {
        require(users[msg.sender].isSeller, "Only sellers can add commodities");
        commodities.push(Commodity(_name, _category, _value, _quantity, _company, msg.sender));
    }

    // Allow users to buy commodities
    function buyCommodity(uint _index) public {
        Commodity storage item = commodities[_index];
        require(item.quantity > 0, "Out of stock");
        require(users[msg.sender].balance >= item.value, "Solde insuffisant");

        users[msg.sender].balance -= item.value;
        item.quantity -= 1;

        payable(item.seller).transfer(item.value); // Transfert au vendeur
    }


    // Get all commodities in the marketplace
    function getCommodities() public view returns (Commodity[] memory) {
        return commodities;
    }

    // Get user details by their address (ID)
    function getUserById(address _userAddress) public view returns (
        string memory firstName, 
        string memory lastName, 
        uint256 age, 
        string memory gender, 
        bool isSeller, 
        string memory email,
        uint256 balance
    ) {
        User storage user = users[_userAddress];
        return (user.firstName, user.lastName, user.age, user.gender, user.isSeller, user.email, user.balance);
    }

    // Update user balance
    function updateBalance(uint256 _amount) public {
        users[msg.sender].balance += _amount;
    }

    function getMyProfile() public view returns (User memory) {
        return users[msg.sender];
    }

    function getBalance(address _user) public view returns (uint256) {
        return users[_user].balance;
    }

    function getEthBalance(address _user) public view returns (uint256) {
        return _user.balance;
    }

}
