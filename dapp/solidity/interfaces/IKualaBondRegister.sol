// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20, KualaBond, RegisteredKualaBond, BondStatus} from "./IKualaBondStructs.sol";

struct KualaBondVerification { 
    uint256 id; 
    uint256 verificationDate; 
    uint256 bondId; 
    address verifier; 
    uint256 sourceChain; 
    uint256 hostChain; 
    uint256 bondAmount; 
    ERC20 sourceErc20; 
}

struct KualaBondContractRegistration { 
    uint256 id; 
    address kualaBondContract; 
    address registra; 
    uint256 registrationDate; 
}

struct KualaBondContractDeRegistration { 
    uint256 id; 
    address kualaBondContract; 
    address deregistra; 
    uint256 deregistrationDate; 
}

interface IKualaBondRegister { 

    function getKualaBondRegistrationIds() view external returns (uint256 [] memory _registrationIds);

    function getKualaBondRegistration(address _kualaBondContract) view external returns (KualaBondContractRegistration memory _kualaBondRegistration);

    function findBondContracts(address _erc20, uint256 _srcChain) view external returns (address [] memory kualaBondContracts);

    function isRegisteredContract(address _kualaBondContract) view external returns (bool _isRegisteredContract);

    function getBondContract(uint256 _registrationId) view external returns(address kualaBondContract);

    function registerBondContract(address kualaBondContract) external returns (uint256 _registrationId);

    function deregisterBondContract(uint256 _registrationId) external returns (uint256 _deregistrationId);

    
    function getRegisteredBond(uint256 _registrationId) view external returns (RegisteredKualaBond memory _rBond);
    
    function findBond(uint256 _bondId, address bondContract, uint256 _chainId) view external returns (KualaBond memory _bond);

    function isRegistered(RegisteredKualaBond memory _rBond) view external returns (bool _isRegistered);

    function registerBond(KualaBond memory _kualaBond) external returns (RegisteredKualaBond memory _rBond);

    function getVerification(uint256 _verficiationId) view external returns (KualaBondVerification memory _kualaBondVerification);

    function updateStatus(uint256 _registrationId, BondStatus _status) external returns (RegisteredKualaBond memory _kualaBond);

}