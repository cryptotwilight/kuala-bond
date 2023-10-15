// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20, KualaBond, BondConfiguration} from "./IKualaBondStructs.sol";

interface IKualaBondContract { 

    function getBondConfiguration() view external returns (BondConfiguration memory _bondConfiguration);   

    function getKualaBond(uint256 _bondId) view external returns (KualaBond memory _bond);
}