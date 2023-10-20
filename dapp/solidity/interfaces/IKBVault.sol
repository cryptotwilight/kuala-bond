// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {RegisteredKualaBond} from "../interfaces/IKualaBondStructs.sol";

interface IKBVault {

    function getIssuedVaultIds() view external returns (uint256 [] memory _ids);

    function getKualaBond(uint256 _bondId) view external returns (RegisteredKualaBond memory _kualaBond);

    function commitBond(RegisteredKualaBond memory _kualaBond) external payable returns (uint256 _vaultId);

    function releaseBond(uint256 _vaultId) external returns (RegisteredKualaBond memory _kualaBond);

}