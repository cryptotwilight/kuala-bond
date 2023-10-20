// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct Locus { 
    address location; 
    uint256 chainId; 
    string name; 
}   

interface IKBRoutingRegistry { 

    function getLoci() view external returns (Locus [] memory _loci);

    function isKnownRemoteAddress(address _address) view external returns (bool _isKnown);

    function getSrcChain(address _address) view external returns (uint256 _chainId);

    function getAddress(uint256 _chainId, string memory _name) view external returns (address _address);

    function getAxelarChainName(uint256 _chainId) view external returns (string memory _chainName);

    function isSupportedAxelarChainName(string memory _chain) view external returns (bool _isSupported);

}