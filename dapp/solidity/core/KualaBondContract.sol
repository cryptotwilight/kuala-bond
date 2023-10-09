// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

import "../interfaces/IKualaBondContract.sol";

contract KualaBondContract is ERC721,ERC721Burnable, IKualaBondContract {
    
    uint256 index; 
    BondConfiguration bondConfiguration; 
    mapping(uint256=>bool) knownBondId; 
    mapping(uint256=>KualaBond) kBondById; 
    address self; 

    constructor(string memory _name, string memory _symbol, BondConfiguration memory _bondConfiguration) ERC721(_name, _symbol) {
        bondConfiguration = _bondConfiguration; 
        self = address(this);
    }

    function getBondConfiguation() view external returns (BondConfiguration memory _bondConfiguration){
        return bondConfiguration; 
    }

    function getKualaBond(uint256 _bondId) view external returns (KualaBond memory _bond){
        return kBondById[_bondId];
    }

    function issueKualaBond(uint256 _amount) external payable returns (KualaBond memory _bond){
        // mint
        IERC20 erc20 = IERC20(bondConfiguration.erc20.token);
        erc20.transferFrom(msg.sender, self, _amount);
        _bond = KualaBond ({
                                id  : getIndex(),  
                                erc20 : bondConfiguration.erc20, 
                                sourceChain : bondConfiguration.chainId, 
                                createDate : block.timestamp, 
                                bondContract : self,
                                amount : _amount 
                            });
        _mint(msg.sender, _bond.id);
        kBondById[_bond.id] = _bond;
        knownBondId[_bond.id] = true;  
        return _bond;
    }

    function liquidateKualaBond(uint256 _bondId) external returns (uint256 _payoutAmount){
        // burn
        delete knownBondId[_bondId];
        KualaBond memory bond_ = kBondById[_bondId];
        delete kBondById[bond_.id];
        _burn(_bondId);
        IERC20 erc20 = IERC20(bondConfiguration.erc20.token);
        erc20.transferFrom(self, msg.sender, bond_.amount);
        return bond_.amount; 
    }

    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }


}
