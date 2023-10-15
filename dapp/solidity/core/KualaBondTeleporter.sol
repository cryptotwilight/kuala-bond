// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
      
import "https://github.com/hyperlane-xyz/hyperlane-monorepo/blob/main/solidity/contracts/interfaces/IMailbox.sol";

import "../interfaces/IOpsRegister.sol";

import {RegisteredKualaBond} from "../interfaces/IKualaBondStructs.sol";
import "../interfaces/IKualaBondTeleporter.sol";
import "../interfaces/IVersion.sol";

contract KualaBondTeleporter is IKualaBondTeleporter, IVersion { 

    string constant vname = "KUALA_BOND_TELEPORTER";
    uint256 constant version = 1; 

    IOpsRegister register; 
    address self; 

    constructor(address _register) {
        register = IOpsRegister(_register); 
        self = address(this);
    }

    function getVName() pure external returns (string memory _name){
        return vname; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }

    function isLocked(KualaBond memory _bond) view external returns (uint256 _isLocked){

    }

    function getReceptionManifest(uint256 _manifestId) view external returns (ManifestDescriptor memory _descriptor){

    }

    function getTeleportDescriptor(uint256 _teleportId) view external returns (TeleportDescriptor memory _descriptor){

    }

    function teleportKualaBond(uint256 _destinationChainId, RegisteredKualaBond memory _kualaBond) external returns (uint256 _teleportId){

    }

    function revertSettlement(Settlement memory _settlement) external returns (uint256 _reversionId){

    }

    function recieve(TeleportDescriptor memory _descriptor) external returns (uint256 _manifestId){

    }

    function recieve(Settlement memory _settlement) external returns (uint256 _confirmationId){

    }
}