// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IOpsRegister.sol";
import "../interfaces/IVersion.sol";

contract OpsRegister is IOpsRegister, IVersion { 

    string constant name = "KUALA_BOND_OPS_REGISTER";
    uint256 constant version = 1; 

    address admin; 
    address self; 

    string [] names; 
    mapping(string=>bool) knownName; 
    mapping(address=>bool) knownAddress; 
    mapping(address=>string) nameByAddress; 
    mapping(string=>address) addressByName; 


    constructor(address _admin) {
        admin = _admin;
        self = address(this);  
    }

    function getVName() pure external returns (string memory _name){
        return name; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getNames() view external returns (string [] memory _names) {
        return names; 
    }

    function addAddress(string memory _name, address _address) external returns (bool _added){
        require(msg.sender == admin, "admin only");
        return addAddressInternal(_name, _address); 
    }

    function addIVersionAddress(address _address) external returns (bool _added) {
        require(msg.sender == admin, "admin only");
        IVersion v_ = IVersion(_address);
        return addAddressInternal(v_.getVName(), _address); 
    }

    function getAddress(string memory _name) view external returns (address _address){
        require(knownName[_name], "unknown name");
        return addressByName[_name];
    }

    function getName(address _address) view external returns (string memory _name){
        require(knownAddress[_address], "unknown address");
        return nameByAddress[_address];
    }
    
    //======================== INTERNAL ===========================================

    function addAddressInternal(string memory _name, address _address) internal returns (bool _added) {
        nameByAddress[_address] = _name; 
        addressByName[_name] = _address;
        if(!knownName[_name]){ 
            knownName[_name] = true; 
            names.push(_name);
        }
        knownAddress[_address] = true;
        return true; 
    }
}