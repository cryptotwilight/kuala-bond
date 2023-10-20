// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
      
import "../interfaces/IOpsRegister.sol";

import {TeleportAction} from "../interfaces/IKualaBondStructs.sol";

import "../interfaces/IKualaBondTeleporter.sol";
import "../interfaces/IKualaBondRegister.sol";
import "../interfaces/IVersion.sol";
import "../interfaces/IKBVault.sol";


import "../interfaces/IKBRoutingRegistry.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import { StringToAddress, AddressToString } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/libs/AddressString.sol';


import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';


contract KualaBondTeleporter is IKualaBondTeleporter, IVersion, AxelarExecutable { 

    string constant vname = "KUALA_BOND_TELEPORTER";
    uint256 constant version = 2; 
    address self; 

    uint256 index; 

    using StringToAddress for string;
    using AddressToString for address;

    string constant KUALA_BOND_REGISTER_CA = "KUALA_BOND_REGISTER";
    string constant KUALA_BOND_RECIEVER_CA = "KUALA_BOND_RECIEVER"; 
    string constant KUALA_BOND_VAULT_CA = "KB_VAULT";
    string constant KUALA_BOND_ROUTING_REGISTRY_CA = "KB_ROUTING_REGISTRY";

    IOpsRegister register; 
    IKualaBondRegister iKBRegister; 
    uint256 chainId; 
    IAxelarGasService public immutable gasService;
    IKBRoutingRegistry routing; 
    IKBVault vault;


    SupportedChain [] chains; 
    mapping(uint256=>bool) knownChainId; 
    mapping(uint256=>TeleportDescriptor) teleportById; 
    mapping(uint256=>TransmissionRecord) transmissionById; 

    constructor(address _register, uint256 _chainId, address _gateway) AxelarExecutable(_gateway) {
        register = IOpsRegister(_register); 
        
        iKBRegister = IKualaBondRegister(register.getAddress(KUALA_BOND_REGISTER_CA));
        vault = IKBVault(register.getAddress(KUALA_BOND_VAULT_CA));
        routing = IKBRoutingRegistry(register.getAddress(KUALA_BOND_ROUTING_REGISTRY_CA)); 

        self = address(this);
        chainId = _chainId; 
    }

    function getVName() pure external returns (string memory _name){
        return vname; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getSupportedChains() view external returns (SupportedChain [] memory _chains) {
        return chains; 
    }

    function getTeleportDescriptor(uint256 _teleportId) view external returns (TeleportDescriptor memory _descriptor){
        return teleportById[_teleportId];
    }

    function teleportKualaBond(uint256 _destinationChainId, RegisteredKualaBond memory _kualaBond) external returns (uint256 _teleportId){
        require(_destinationChainId != chainId, "cannot teleport to same chain");
        require(knownChainId[_destinationChainId], "unknown chain id");
        require(iKBRegister.isRegistered(_kualaBond), "registered bonds only");
        IERC721 bondContract_ = IERC721(_kualaBond.bond.bondContract);
        bondContract_.transferFrom(msg.sender, self, _kualaBond.bond.id);
      

        _teleportId = getIndex();
        teleportById[_teleportId] = TeleportDescriptor({  
                                                        id                  : _teleportId,  
                                                        bond                : _kualaBond,  
                                                        holder              : msg.sender,  
                                                        teleportDate        : block.timestamp,  
                                                        sourceChain         :  chainId, 
                                                        destinationChain    : _destinationChainId
                                                    });

        iKBRegister.updateStatus(_kualaBond.registrationId, BondStatus.TELEPORTED);

        uint256 [5] memory a = [_kualaBond.bond.id, _kualaBond.bond.createDate, _kualaBond.registrationId, _kualaBond.bond.amount, vault.commitBond(_kualaBond)];

        bytes memory payload_ = abi.encode(chainId, _kualaBond.bond.bondContract, a, 
                                            _kualaBond.bond.erc20.name, 
                                            _kualaBond.bond.erc20.symbol, 
                                            _kualaBond.bond.erc20.token, 
                                            msg.sender, uint256(TeleportAction.MATERIALIZE), 
                                            routing.getAddress(_destinationChainId, KUALA_BOND_RECIEVER_CA) );
        post(routing.getAxelarChainName(_destinationChainId), payload_);
        /// axelar here
        return _teleportId; 
    }

    function post(string memory _axelarChainName, bytes memory _payload) internal returns (bool _success) {

        string memory stringAddress = self.toString();
        //Pay for gas. We could also send the contract call here but then the sourceAddress will be that of the gas receiver which is a problem later.
        gasService.payNativeGasForContractCall{ value: msg.value }(self, _axelarChainName, stringAddress, _payload, msg.sender);
        //Call the remote contract.
        gateway.callContract(_axelarChainName, stringAddress, _payload);

        return true; 
    }

    function transmitSettlement(Settlement memory _settlement) external returns (uint256 _transmissionId){

    }

    function getTransmissionRecord(uint256 _transmissionId) view external returns (TransmissionRecord memory _transmissionRecord){
        return transmissionById[_transmissionId];
    }   

    function addSupportedChain(SupportedChain memory _chain) external returns (bool _added) {
        require(!knownChainId[_chain.id], "chain already supported");
        chains.push(_chain);
        return true; 
    }

    //========================================= INTERNAL =============================================================================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }

}