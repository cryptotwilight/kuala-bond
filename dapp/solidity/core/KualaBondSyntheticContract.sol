// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

import "../interfaces/IVersion.sol";
import {BondType} from "../interfaces/IKualaBondStructs.sol";
import "../interfaces/IKualaBondSyntheticContract.sol";

contract KualaBondSyntheticContract is ERC721, ERC721Burnable, IKualaBondSyntheticContract, IVersion { 

    string constant vname = "KUALA_BOND_SYNTHETIC_CONTRACT";
    uint256 constant version = 1; 

    uint256 index; 

    address administrator; 
    address self; 

    BondConfiguration bondConfiguration;
    mapping(uint256=>KualaBond) bondById;
    mapping(uint256=>uint256) sourceBondIdByReBondId; 
    mapping(uint256=>KualaBond) sourceBondById; 
    mapping(uint256=>mapping(address=>mapping(uint256=>bool))) existsBondTypeByBondIdByBondContractByChainId; 

    mapping(uint256=>Settlement) settlementById; 

    constructor(string memory _name, string memory _symbol, address _admin, BondConfiguration memory _bondConfiguration) ERC721(_name, _symbol) {
        administrator = _admin; 
        bondConfiguration = _bondConfiguration; 
        self = address(this);
    }

    function getVName() pure external returns (string memory _name){
        return vname; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getBondConfiguration() view external returns (BondConfiguration memory _bondConfiguration){
        return bondConfiguration; 
    }

    function getKualaBond(uint256 _reBondId) view external returns (KualaBond memory _bond){
        return bondById[_reBondId]; 
    }

    function getSourceBond(uint256 _srcBondId)  view external returns (KualaBond memory _bond) {
        return sourceBondById[_srcBondId];
    }

    function isVerifiedSettlement(Settlement memory _settlement) view external returns (bool _isVerified){
        
    }

    function reIssueKualaBond(KualaBond memory _srcBond) external returns (KualaBond memory _reBond){
        require(!existsBondTypeByBondIdByBondContractByChainId[_srcBond.sourceChain][_srcBond.bondContract][_srcBond.id], "bond already re-issued");
        require(verifyBond(_srcBond), "unable to verify source bond");
        existsBondTypeByBondIdByBondContractByChainId[_srcBond.sourceChain][_srcBond.bondContract][_srcBond.id] = true; 
        _reBond = KualaBond({
                                id : getIndex(), 
                                bondType : BondType.SYNTHETIC, 
                                erc20 : _srcBond.erc20,
                                sourceChain : bondConfiguration.chainId, 
                                createDate : block.timestamp, 
                                bondContract : self,  
                                amount : _srcBond.amount
                            });
        existsBondTypeByBondIdByBondContractByChainId[_reBond.sourceChain][_reBond.bondContract][_reBond.id] = true;
        bondById[_reBond.id] = _reBond; 
        sourceBondById[_srcBond.id] = _srcBond;
         _mint(msg.sender, _reBond.id);
        return _reBond; 
    }

    function getSettlement(uint256 _settlementId) view external returns (Settlement memory _settlement) {
        return settlementById[_settlementId];
    }

    function settleKualaBond(uint256 _reBondId) external returns (Settlement memory _settlement){
        // resolve to NATURAL bond or Collateral 
        
    }

    // ========================================== INTERNAL =============================================================
    function verifyBond(KualaBond memory _bond) internal returns (bool _verified) {
        // go back cross chain and verifify that this bond is Kosher
    

        return true; 
    }


    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }

}