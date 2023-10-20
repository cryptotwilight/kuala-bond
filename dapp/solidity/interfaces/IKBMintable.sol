// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct Mint {
    uint256 id; 
    uint256 amount; 
    address sentTo; 
    uint256 mintDate; 
}

interface IKBMintable { 

    function getMints() view external returns (uint256 [] memory _mintIds);

    function mint(address to, uint256 _amount) external returns (uint256 _mintId);

    function getMint(uint256 _mintId) view external returns (Mint memory _mint);
}