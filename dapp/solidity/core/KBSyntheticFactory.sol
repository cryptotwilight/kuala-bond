// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IVersion.sol";
import "../interfaces/IOpsRegister.sol";
import "../interfaces/IKBSyntheticFactory.sol";
import "./KualaBondSyntheticContract.sol";

contract KBSyntheticFactory is IKBSyntheticFactory, IVersion {

    string constant vname = "KB_SYNTHETIC_FACTORY"; 
    uint256 constant version = 1; 

    string constant KUALA_BOND_TELEPORT_RECIEVER_CA = "KUALA_BOND_RECIEVER"; 
    string constant KUALA_BOND_ADMIN_CA             = "KUALA_BOND_ADMIN";

    IOpsRegister register; 
    uint256 chainId; 
    address [] contracts; 

    constructor(address _register, uint256 _chainId) {
        register = IOpsRegister(_register);
        chainId = _chainId; 
    }

    function getVName() pure external returns (string memory _name){
        return vname; 
    }

    function getVVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getIssuedBondContracts() view external returns (address [] memory _contracts) {
        return contracts;
    }

    function getKualaBondSyntheticContract(string memory _name, string memory _symbol, BondConfiguration memory _bondConfiguration) external returns (address _kualaBondSyntheticContract){
        require(msg.sender == register.getAddress(KUALA_BOND_TELEPORT_RECIEVER_CA) 
            || msg.sender == register.getAddress(KUALA_BOND_ADMIN_CA), "teleport reciever only");
        KualaBondSyntheticContract sBondContract = new KualaBondSyntheticContract(_name, _symbol, register.getAddress(KUALA_BOND_ADMIN_CA), _bondConfiguration);
        _kualaBondSyntheticContract = address(sBondContract);
        contracts.push(_kualaBondSyntheticContract);
        return _kualaBondSyntheticContract; 
    }


} 