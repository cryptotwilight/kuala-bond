// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Settlement, ERC20, KualaBond, RegisteredKualaBond} from "./IKualaBondStructs.sol";

struct ManifestDescriptor { 
    uint256 id; 
    CompressedTeleportDescriptor descriptor; 
    uint256 reBondId; 
    address bondContract; 
}

struct SettlementConfirmation { 
    uint256 id; 
    Settlement settlement; 
    uint256 completionDate; 
}

struct CompressedTeleportDescriptor { 
        uint256 teleportId;
        KualaBond bond; 
        uint256 srcChainRegistrationId; 
        address owner; 
        uint256 vaultId; 
}

interface IKualaBondTeleportReciever { 
        
    function getRecievedBonds() view external returns (RegisteredKualaBond [] memory _rBonds);

}