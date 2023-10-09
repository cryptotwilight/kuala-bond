// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IKualaBondRegister.sol";


contract KualaBondRegister is IKualaBondRegister { 

    address owner; 
    address self; 

    mapping(address=>address[]) bondContractsByErc20; 
    mapping(uint256=>RegisteredKualaBond) registeredKualaBondById; 
    mapping(uint256=>mapping(address=>mapping(uint256=>bool))) hasKualaBondByBondContractByChainId;
    mapping(uint256=>mapping(address=>mapping(uint256=>KualaBond))) kualaBondByIdByBondContractByChainId;
    mapping(uint256=>KualaBondVerification) kualaBondVerificationById; 


    constructor(address _owner) { 
        owner = _owner; 
        self = address(this);
    }

    function findBondContracts(address _erc20) view external returns (address [] memory kualaBondContracts){
        return bondContractsByErc20[_erc20];
    }

    function getBond(uint256 _registrationId) view external returns (RegisteredKualaBond memory _rBond){
        return registeredKualaBondById[_registrationId];
    }
    
    function findBond(uint256 _bondId, address _bondContract, uint256 _chainId) view external returns (KualaBond memory _bond){
        require(hasKualaBondByBondContractByChainId[_chainId][_bondContract][_bondId], "unknown bond");
        return kualaBondByIdByBondContractByChainId[_chainId][_bondContract][_bondId];
    }

    function registerBond(KualaBond memory _kualaBond) external returns (RegisteredKualaBond memory _rBond){

    }

    function getVerification(uint256 _verficiationId) view external returns (KualaBondVerification memory _kualaBondVerification){

    }


}