// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ecommerce {
    struct Commodity {
        string name;
        string category;
        uint256 value;
        uint256 quantity;
        string company;
        address seller;
        string image; // Lien image (URL ou IPFS)
    }

    struct User {
        string firstName;
        string lastName;
        uint256 age;
        string gender;
        bool isSeller;
        string email;
        uint256 balance;
        string image; // Lien image (URL ou IPFS)
    }

    struct Order {
        uint256 id;
        address buyer;
        uint256 commodityId;
        uint256 quantity;
        uint256 totalPrice;
        uint256 timestamp;
        string status; // "Pending", "Shipped", "Delivered"
    }

    mapping(address => User) public users;
    Commodity[] public commodities;
    Order[] public orders;
    mapping(address => uint256[]) public userOrders;

    // Enregistrer un utilisateur avec image
    function register(
        string memory _firstName,
        string memory _lastName,
        uint256 _age,
        string memory _gender,
        bool _isSeller,
        string memory _email,
        string memory _image
    ) public {
        users[msg.sender] = User(
            _firstName,
            _lastName,
            _age,
            _gender,
            _isSeller,
            _email,
            0,
            _image
        );
    }

    // Modifier son profil avec image
    function updateProfile(
        string memory _firstName,
        string memory _lastName,
        uint256 _age,
        string memory _gender,
        string memory _email,
        string memory _image
    ) public {
        User storage user = users[msg.sender];
        require(bytes(user.firstName).length > 0, "User not registered");
        user.firstName = _firstName;
        user.lastName = _lastName;
        user.age = _age;
        user.gender = _gender;
        user.email = _email;
        user.image = _image;
    }

    // Dépôt d'ETH dans le solde interne
    function deposit() public payable {
        require(msg.value > 0, "Montant invalide");
        users[msg.sender].balance += msg.value;
    }

    // Ajouter un produit avec image
    function addCommodity(
        string memory _name,
        string memory _category,
        uint256 _value,
        uint256 _quantity,
        string memory _company,
        string memory _image
    ) public {
        require(users[msg.sender].isSeller, "Only sellers can add commodities");
        commodities.push(
            Commodity(_name, _category, _value, _quantity, _company, msg.sender, _image)
        );
    }

    // Version modifiée de la fonction buyCommodity pour paiement direct
    function buyCommodity(uint _index, uint _quantity) public payable {
        Commodity storage item = commodities[_index];
        require(item.quantity >= _quantity, "Not enough stock");
        
        uint256 totalCost = (item.value * 1 gwei) * _quantity;
        require(msg.value >= totalCost, "Paiement insuffisant");
        
        // Réduire le stock
        item.quantity -= _quantity;
        
        // Transférer le paiement directement au vendeur
        payable(item.seller).transfer(totalCost);
        
        // Si l'utilisateur a payé plus que nécessaire, rembourser la différence
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
        
        // Créer la commande
        uint256 orderId = orders.length;
        orders.push(
            Order(orderId, msg.sender, _index, _quantity, totalCost, block.timestamp, "Pending")
        );
        userOrders[msg.sender].push(orderId);
        
        // Émettre un événement pour le suivi
        emit CommodityPurchased(msg.sender, _index, _quantity, totalCost, orderId);
    }

    // Ajout d'un événement pour le suivi des achats
    event CommodityPurchased(
        address indexed buyer,
        uint indexed commodityIndex,
        uint quantity,
        uint256 totalCost,
        uint256 orderId
    );

    // Changer le statut d'une commande
    function updateOrderStatus(uint256 _orderId, string memory _status) public {
        Order storage order = orders[_orderId];
        Commodity storage product = commodities[order.commodityId];
        require(msg.sender == product.seller, "Only seller can update status");
        order.status = _status;
    }

    // Voir tous les produits
    function getCommodities() public view returns (Commodity[] memory) {
        return commodities;
    }

    // Voir toutes les commandes
    function getOrders() public view returns (Order[] memory) {
        return orders;
    }

    // Voir les commandes d'un utilisateur
    function getOrdersByUser(address _user) public view returns (Order[] memory) {
        uint256[] memory orderIds = userOrders[_user];
        Order[] memory result = new Order[](orderIds.length);
        for (uint i = 0; i < orderIds.length; i++) {
            result[i] = orders[orderIds[i]];
        }
        return result;
    }

    // Voir un utilisateur
    function getUserById(address _userAddress) public view returns (
        string memory firstName, 
        string memory lastName, 
        uint256 age, 
        string memory gender, 
        bool isSeller, 
        string memory email,
        uint256 balance,
        string memory image
    ) {
        User storage user = users[_userAddress];
        return (
            user.firstName, 
            user.lastName, 
            user.age, 
            user.gender, 
            user.isSeller, 
            user.email, 
            user.balance,
            user.image
        );
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
