// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20, KualaBond} from "./IKualaBondStructs.sol";

struct BondConfiguration { 
    uint256 chainId; 
    ERC20 erc20; 
}

interface IKualaBondContract { 

    function getBondConfiguation() view external returns (BondConfiguration memory _bondConfiguration);

    function getKualaBond(uint256 _bondId) view external returns (KualaBond memory _bond);

    function issueKualaBond(uint256 _amount) external payable returns (KualaBond memory _bond);

    function liquidateKualaBond(uint256 _bondId) external returns (uint256 _payoutAmount);

}