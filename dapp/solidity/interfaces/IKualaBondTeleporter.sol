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

struct ManifestDescriptor { 
    uint256 id; 
    TeleportDescriptor descriptor; 
    uint256 reBondId; 
    address bondContract; 
}

interface IKualaBondTeleporter { 

    function getReceptionManifest(uint256 _manifestId) view external returns (ManifestDescriptor memory _descriptor);

    function getTeleportDescriptor(uint256 _teleportId) view external returns (TeleportDescriptor memory _descriptor);

    function teleportKualaBond(uint256 _destinationChainId, RegisteredKualaBond memory _kualaBond) external returns (uint256 _teleportId);

    function revertSettlement(Settlement memory _settlement) external returns (uint256 _reversionId);

    function recieve(TeleportDescriptor memory _descriptor) external returns (uint256 _manifestId);

    function recieve(Settlement memory _settlement) external returns (uint256 _confirmationId);

}