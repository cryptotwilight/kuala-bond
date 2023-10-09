// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {KualaBond} from "./IKualaBondStructs.sol";

interface IKualaBondTeleporter { 

    function teleportKualaBond(uint256 _chainId, KualaBond memory _kualaBond) external returns (uint256 _teleportId);

    function isLocked(KualaBond memory _bond) view external returns (uint256 _isLocked);

}