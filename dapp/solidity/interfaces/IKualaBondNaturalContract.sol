// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IKualaBondContract.sol";
import {ERC20, KualaBond, BondConfiguration} from "./IKualaBondStructs.sol";

interface IKualaBondNaturalContract is IKualaBondContract { 

    function issueKualaBond(uint256 _amount) external payable returns (KualaBond memory _bond);

    function liquidateKualaBond(uint256 _bondId) external returns (uint256 _payoutAmount);

}