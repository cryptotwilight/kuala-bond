// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct ERC20 { 
    string name; 
    string symbol; 
    address token; 
}

struct KualaBond {
    uint256 id; 
    ERC20 erc20; 
    uint256 sourceChain; 
    uint256 createDate; 
    address bondContract; 
    uint256 amount; // numerical quanity of currency NOT value
}

interface IKualaBondStructs { 

}