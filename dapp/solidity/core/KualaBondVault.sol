// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "../interfaces/IOpsRegister.sol";
import "../interfaces/IVersion.sol";
import "../interfaces/IKBVault.sol";

struct VaultStats {
    uint256 bondCount;
    uint256 totalValue; 
}


contract KualaBondVault is IKBVault, IVersion {

    string constant name = "KB_VAULT";
    uint256 constant version = 1; 

    IOpsRegister register; 
    uint256 index; 
    address self; 

    string constant KUALA_BOND_ADMIN_CA = "KUALA_BOND_ADMIN";
    string constant KUALA_BOND_TELEPORTER_CA = "KUALA_BOND_TELEPORTER";
    string constant KUALA_BOND_RECIEVER_CA = "KUALA_BOND_RECIEVER";
    
    uint256 [] ids;
    mapping(uint256=>RegisteredKualaBond) kualaBondByVaultId;

    constructor(address _opsRegistry) {
        register = IOpsRegister(_opsRegistry);
        self = address(this);
    }

   function getVName() pure  external returns (string memory _name){
        return name; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getVaultStats() view external returns (VaultStats memory  _vaultStats){
        uint256 totalValue_ = 0;
        for(uint256 x = 0; x < ids.length; x++) {
            totalValue_ += kualaBondByVaultId[x].bond.amount; 
        }
        _vaultStats = VaultStats({
                                    bondCount : ids.length,
                                    totalValue : totalValue_
                                });
        return _vaultStats;
    }

    function getIssuedVaultIds() view external returns (uint256 [] memory _ids){
        return ids; 
    }

    function getKualaBond(uint256 _bondId) view external returns (RegisteredKualaBond memory _kualaBond){
        return kualaBondByVaultId[_bondId];
    }

    function commitBond(RegisteredKualaBond memory _kualaBond) external payable returns (uint256 _vaultId){
        require(msg.sender == register.getAddress(KUALA_BOND_TELEPORTER_CA)
        || msg.sender == register.getAddress(KUALA_BOND_ADMIN_CA),"authorised only");
        IERC721 bondContract_ = IERC721(_kualaBond.bond.bondContract);
        bondContract_.transferFrom(msg.sender, self, _kualaBond.bond.id);
        _vaultId = getIndex(); 
        ids.push(_vaultId);
        kualaBondByVaultId[_vaultId] = _kualaBond;
        return _vaultId; 
    }

    function releaseBond(uint256 _vaultId) external returns (RegisteredKualaBond memory _kualaBond){
         require(msg.sender == register.getAddress(KUALA_BOND_RECIEVER_CA)
         || msg.sender == register.getAddress(KUALA_BOND_ADMIN_CA),"authorised only");
        RegisteredKualaBond memory kualaBond_ = kualaBondByVaultId[_vaultId];
        IERC721 bondContract_ = IERC721(kualaBond_.bond.bondContract);
        bondContract_.transferFrom(self, msg.sender, kualaBond_.bond.id);
        return kualaBond_;
    }

    //=============================================== INTERNAL =============================================================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }
}