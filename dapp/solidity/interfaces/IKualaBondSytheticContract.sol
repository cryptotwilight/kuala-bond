// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IKualaBondContract.sol";

import {ERC20, KualaBond, BondConfiguration, SettlementType, Settlement} from "../interfaces/IKualaBondStructs.sol";


interface IKualaBondSyntheticContract is IKualaBondContract {

    function getSourceBond(uint256 _srcBondId)  view external returns (KualaBond memory _bond);

    function isVerifiedSettlement(Settlement memory _settlement) view external returns (bool _isVerified);

    function reIssueKualaBond(KualaBond memory _srcBond) external returns (KualaBond memory _reBond);
     
    function settleKualaBond(uint256 _reBondId) external returns (Settlement memory settlement);

}