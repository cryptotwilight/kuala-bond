// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20, KualaBond} from "./IKualaBondStructs.sol";

struct RegisteredKualaBond { 
    KualaBond bond; 
    uint256 registrationId; 
    uint256 verificationId; 
}

struct KualaBondVerification { 
    uint256 verificationDate; 
    address verifier; 
    uint256 sourceChain; 
    uint256 hostChain; 
    uint256 bondAmount; 
    ERC20 sourceErc20; 
}

interface IKualaBondRegister { 

    function findBondContracts(address _erc20) view external returns (address [] memory kualaBondContracts);

    function getBond(uint256 _registrationId) view external returns (RegisteredKualaBond memory _rBond);
    
    function findBond(uint256 _bondId, address bondContract, uint256 _chainId) view external returns (KualaBond memory _bond);

    function registerBond(KualaBond memory _kualaBond) external returns (RegisteredKualaBond memory _rBond);

    function getVerification(uint256 _verficiationId) view external returns (KualaBondVerification memory _kualaBondVerification);
}