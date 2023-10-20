// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {KualaBond, RegisteredKualaBond, Settlement} from "./IKualaBondStructs.sol";

struct TeleportDescriptor { 
    uint256 id; 
    RegisteredKualaBond bond; 
    address holder; 
    uint256 teleportDate; 
    uint256 sourceChain; 
    uint256 destinationChain; 
}

struct TransmissionRecord { 
    uint256 id; 
    Settlement settlement; 
    uint256 transmissionDate; 
}

struct SupportedChain { 
    uint256 id; 
    string [] erc20s; 
}

interface IKualaBondTeleporter { 
    
    function getSupportedChains() view external returns (SupportedChain [] memory _supportedChain);

    function getTeleportDescriptor(uint256 _teleportId) view external returns (TeleportDescriptor memory _descriptor);

    function teleportKualaBond(uint256 _destinationChainId, RegisteredKualaBond memory _kualaBond) external returns (uint256 _teleportId);

    function transmitSettlement(Settlement memory _settlement) external returns (uint256 _transmissionId);

    function getTransmissionRecord(uint256 _transmissionId) view external returns (TransmissionRecord memory _transmissionRecord);

}