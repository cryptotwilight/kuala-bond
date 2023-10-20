// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IOpsRegister.sol";
import "../interfaces/IKBRoutingRegistry.sol";
import "../interfaces/IVersion.sol";

contract KBRoutingRegistry is IKBRoutingRegistry, IVersion { 

    string constant vname = "KB_ROUTING_REGISTRY"; 
    uint256 constant version = 1; 

    string constant KUALA_BOND_ADMIN_CA = "KUALA_BOND_ADMIN";

    IOpsRegister register; 
    uint256 chainId; 
    address [] lociAddresses; 
    mapping(address=>Locus) locusByAddress; 
    mapping(address=>bool) isKnownByRemoteAddress;
    mapping(uint256=>mapping(string=>Locus)) locusByNameByChainId; 
    mapping(uint256=>string) chainNameById; 
    mapping(string=>bool) isSupportedAxelarChain;

    constructor(address _register, uint256 _chainId) {
        register = IOpsRegister(_register);
        chainId = _chainId; 
    }

    function getVName() pure external returns (string memory _name) {
        return vname; 
    }

    function getVVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getLoci() view external returns (Locus [] memory _loci){
        _loci = new Locus[](lociAddresses.length);
        for(uint256 x = 0; x < lociAddresses.length; x++){
            _loci[x] = locusByAddress[lociAddresses[x]];
        }
        return _loci; 
    }

    function getAddress(uint256 _chainId, string memory _name) view external returns (address _address) {
        return locusByNameByChainId[_chainId][_name].location;
    }

    function isKnownRemoteAddress(address _address) view external returns (bool _isKnown){
        return isKnownByRemoteAddress[_address];
    }

    function getSrcChain(address _address) view external returns (uint256 _chainId){
        return locusByAddress[_address].chainId; 
    }

    function getAxelarChainName(uint256 _chainId) view external returns (string memory _chainName){
        return chainNameById[_chainId];
    }

    function isSupportedAxelarChainName(string memory _chain) view external returns (bool _isSupported){
        return isSupportedAxelarChain[_chain];
    }


    function addSupportedAxelarChain(uint256 _chainId, string memory _chainName) external returns (bool _added) {
        require(msg.sender == register.getAddress(KUALA_BOND_ADMIN_CA), "admin only");
        chainNameById[_chainId] = _chainName; 
        isSupportedAxelarChain[_chainName] = true; 
        return true; 
    }

    function addRemoteAddress(address _address, uint256 _chainId, string memory _name) external returns (bool _added) {
        require(msg.sender == register.getAddress(KUALA_BOND_ADMIN_CA), "admin only");
        lociAddresses.push(_address);
        locusByAddress[_address] = Locus({ 
                                            location : _address, 
                                            chainId  : _chainId, 
                                            name : _name
                                        });
        return true; 
    } 
}