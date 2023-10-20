// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BondConfiguration} from "../interfaces/IKualaBondStructs.sol";

interface IKBSyntheticFactory { 

    function getKualaBondSyntheticContract(string memory _name, string memory _symbol, BondConfiguration memory _bondConfiguration) external returns (address _kualaBondSyntheticContract);

}