// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { StringToAddress, AddressToString } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/libs/AddressString.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


import {BondType, TeleportAction} from "../interfaces/IKualaBondStructs.sol";

import "../interfaces/IKualaBondSyntheticContract.sol";

import "../interfaces/IVersion.sol";
import "../interfaces/IKualaBondRegister.sol";
import "../interfaces/IOpsRegister.sol";
import "../interfaces/IKualaBondTeleportReciever.sol";
import "../interfaces/IKBSyntheticFactory.sol";
import "../interfaces/IKBRoutingRegistry.sol";

contract KualaBondReciever is AxelarExecutable, IKualaBondTeleportReciever, IVersion  { 

    string constant vname = "KUALA_BOND_RECIEVER"; 
    uint256 constant version = 2;  

    string constant KUALA_BOND_REGISTER_CA = "KUALA_BOND_REGISTER";
    string constant KUALA_BOND_CONTRACT_ADMIN_CA = "KUALA_BOND_ADMIN"; 
    string constant AXELAR_GAS_SERVICE_CA = "AXELAR_GAS_SERVICE";
    string constant KB_SYNTHETIC_FACTORY_CA = "KB_SYNTHETIC_FACTORY";
    string constant KB_ROUTING_REGISTRY_CA = "KB_ROUTING_REGISTRY";

    using StringToAddress for string;
    using AddressToString for address;

    address self; 
    uint256 index; 

    uint256 chainId; 
    IOpsRegister register;
    IKualaBondRegister iKBRegister; 
    IKBSyntheticFactory syntheticBondContractFactory; 
    IKBRoutingRegistry routingRegistry; 

    IAxelarGasService public immutable gasService;


    uint256 [] registeredKualaBondIds; 
    mapping(uint256=>RegisteredKualaBond) registeredKualaBondById; 
    mapping(uint256=>CompressedTeleportDescriptor) compressedTeleportById; 

    constructor(address _register, uint256 _chainId, address _gateway) AxelarExecutable(_gateway) {
        register = IOpsRegister(_register);
        iKBRegister = IKualaBondRegister(register.getAddress(KUALA_BOND_REGISTER_CA));
        gasService = IAxelarGasService(register.getAddress(AXELAR_GAS_SERVICE_CA));
        syntheticBondContractFactory = IKBSyntheticFactory(register.getAddress(KB_SYNTHETIC_FACTORY_CA));
        routingRegistry = IKBRoutingRegistry(register.getAddress(KB_ROUTING_REGISTRY_CA));
        chainId = _chainId; 
        self = address(this);
    } 

    function getVName() pure  external returns (string memory _name){
        return vname; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getRecievedBonds() view external returns (RegisteredKualaBond [] memory _rBonds) {
        _rBonds = new RegisteredKualaBond[](registeredKualaBondIds.length);
        for(uint256 x = 0; x < registeredKualaBondIds.length; x++) {
            _rBonds[x] = registeredKualaBondById[registeredKualaBondIds[x]];
        }
        return _rBonds; 
    }

    //=============================================== INTERNAL ==========================================================================

    function _execute( string calldata _srcChain, /*sourceChain*/  string calldata sourceAddress, bytes calldata payload) internal override {
        require(routingRegistry.isSupportedAxelarChainName(_srcChain), string.concat("un-supported chain",_srcChain));
        require(routingRegistry.isKnownRemoteAddress(sourceAddress.toAddress()), string.concat("unknown remote address",sourceAddress));

        (
        uint256 originChain_, 
        address bondContract_, 
        uint256[5] memory a, 
        string memory token_, 
        string memory symbol_, 
        address tokenContract_,
        address owner_, 
        uint256 action_) = abi.decode(payload, (uint256, address, uint256[5] , string, string, address, address, uint256));

        uint256 teleportId_ = getIndex();
        ERC20 memory erc20_ = ERC20({
                                        name : token_, 
                                        symbol : symbol_,
                                        token : tokenContract_, 
                                        chainId : originChain_  
                                    });
        KualaBond memory bond_ = KualaBond({
                                                id : a[0], 
                                                bondType : BondType.NATURAL,  
                                                erc20  : erc20_,
                                                sourceChain : originChain_, 
                                                createDate : a[1],
                                                bondContract : bondContract_,  
                                                amount : a[3],
                                                status : BondStatus.ISSUED
                                            });                                                                                              
        compressedTeleportById[teleportId_] = CompressedTeleportDescriptor({
                                                                    teleportId : teleportId_,
                                                                    bond : bond_, 
                                                                    srcChainRegistrationId : a[2],
                                                                    owner : owner_,
                                                                    vaultId : a[4]
                                                                });
        if(action_ == uint256(TeleportAction.MATERIALIZE)) {
            materialise(compressedTeleportById[teleportId_]);
        }
        if(action_ == uint256(TeleportAction.SETTLE)) {
            settle(compressedTeleportById[teleportId_]);
        }
    }

    function settle(CompressedTeleportDescriptor memory _tDescriptor) internal { 
        // return funds 
        require(_tDescriptor.bond.sourceChain == chainId, "chain id mis-match");
    }


    function materialise(CompressedTeleportDescriptor memory _tDescriptor) internal {
        require(_tDescriptor.bond.sourceChain != chainId, "cannot materialise on home chain");
        address [] memory localChainBondContracts = iKBRegister.findBondContracts(_tDescriptor.bond.erc20.token, _tDescriptor.bond.erc20.chainId);
        IKualaBondSyntheticContract sBondContract;
        if(localChainBondContracts.length > 0){
            sBondContract = IKualaBondSyntheticContract(localChainBondContracts[0]);
            
        }
        else { 
            string memory name_ = string.concat("KUALA BOND SYNTHETIC FOR ", _tDescriptor.bond.erc20.name); 
            string memory symbol_ = string.concat("KB", _tDescriptor.bond.erc20.symbol);
            BondConfiguration memory bc_ = BondConfiguration({
                                                                            chainId  : _tDescriptor.bond.sourceChain,
                                                                            erc20 : _tDescriptor.bond.erc20,  
                                                                            bondType : BondType.SYNTHETIC 
            });
            sBondContract = IKualaBondSyntheticContract(syntheticBondContractFactory.getKualaBondSyntheticContract(name_, symbol_, bc_));
        }
        KualaBond memory reBond_ = sBondContract.reIssueKualaBond(_tDescriptor.bond, _tDescriptor.vaultId);
        RegisteredKualaBond memory rBond_ = iKBRegister.registerBond(reBond_);
        registeredKualaBondIds.push(rBond_.registrationId); 
        registeredKualaBondById[rBond_.registrationId] = rBond_; 
        IERC721 erc721 = IERC721(address(sBondContract)); 
        erc721.transferFrom(self, _tDescriptor.owner, reBond_.id);
    }


    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }


}