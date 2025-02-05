// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LandRegistry {
    struct Land {
        uint256 id;
        string location;
        uint256 area;
        address payable owner;
        bool isRegistered;
    }

    mapping(uint256 => Land) public lands;
    mapping(address => bool) public registeredUsers;
    uint256 public landCounter;
    address public admin;

    event LandRegistered(uint256 indexed landId, address indexed owner, string location, uint256 area);
    event LandTransferred(uint256 indexed landId, address indexed from, address indexed to);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyOwner(uint256 _landId) {
        require(lands[_landId].owner == msg.sender, "Only land owner can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerUser(address _user) public onlyAdmin {
        registeredUsers[_user] = true;
    }

    function registerLand(string memory _location, uint256 _area) public {
        require(registeredUsers[msg.sender], "User not registered");
        
        landCounter++;
        lands[landCounter] = Land(landCounter, _location, _area, payable(msg.sender), true);
        
        emit LandRegistered(landCounter, msg.sender, _location, _area);
    }

    function transferLand(uint256 _landId, address payable _newOwner) public onlyOwner(_landId) {
        require(registeredUsers[_newOwner], "New owner not registered");
        
        lands[_landId].owner = _newOwner;
        emit LandTransferred(_landId, msg.sender, _newOwner);
    }

    function getLandDetails(uint256 _landId) public view returns (uint256, string memory, uint256, address) {
        require(lands[_landId].isRegistered, "Land not registered");
        
        Land memory land = lands[_landId];
        return (land.id, land.location, land.area, land.owner);
    }
}
