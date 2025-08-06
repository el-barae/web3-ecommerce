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
    }

    struct User {
        string firstName;
        string lastName;
        uint256 age;
        string gender;
        bool isSeller;
    }

    mapping(address => User) public users;
    Commodity[] public commodities;

    function register(string memory _firstName, string memory _lastName, uint256 _age, string memory _gender, bool _isSeller) public {
        users[msg.sender] = User(_firstName, _lastName, _age, _gender, _isSeller);
    }

    function addCommodity(string memory _name, string memory _category, uint256 _value, uint256 _quantity, string memory _company) public {
        require(users[msg.sender].isSeller, "Only sellers can add commodities");
        commodities.push(Commodity(_name, _category, _value, _quantity, _company, msg.sender));
    }

    function buyCommodity(uint _index) public payable {
        Commodity storage item = commodities[_index];
        require(item.quantity > 0, "Out of stock");
        require(msg.value >= item.value, "Insufficient funds");
        
        item.quantity -= 1;
        payable(item.seller).transfer(msg.value);
    }

    function getCommodities() public view returns (Commodity[] memory) {
        return commodities;
    }
}
