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
        string password; 
        uint256 balance;
    }

    mapping(address => User) public users;
    Commodity[] public commodities;

    // Register a new user with email, password, and initial balance
    function register(
        string memory _firstName,
        string memory _lastName,
        uint256 _age,
        string memory _gender,
        bool _isSeller,
        string memory _email,
        string memory _password
    ) public {
        users[msg.sender] = User(_firstName, _lastName, _age, _gender, _isSeller, _email, _password, 0);
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
    function buyCommodity(uint _index) public payable {
        Commodity storage item = commodities[_index];
        require(item.quantity > 0, "Out of stock");
        require(msg.value >= item.value, "Insufficient funds");

        // Deduct from user's balance
        users[msg.sender].balance -= item.value;

        item.quantity -= 1;
        payable(item.seller).transfer(msg.value);
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

    // Get user's balance
    function getBalance(address _userAddress) public view returns (uint256) {
        return users[_userAddress].balance;
    }
}
