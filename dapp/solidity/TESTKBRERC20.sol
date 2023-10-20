// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

import "./interfaces/IOpsRegister.sol";
import "./interfaces/IKBMintable.sol";

contract KualaBondTestRewardToken is ERC20, Ownable, ERC20Permit, IKBMintable {

    string constant KUALA_BOND_POOL_CA = "KUALA_BOND_POOL";
    uint256 index; 

    IOpsRegister register; 
    uint256 [] mintIds;
    mapping(uint256=>Mint) mintById; 

    constructor(address initialOwner, address _register, string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
        Ownable(initialOwner)
        ERC20Permit(_name)
    {
        register = IOpsRegister(_register);
    }

    function getMints() view external returns (uint256 [] memory _mintIds){
        return mintIds; 
    }

    function mint(address to, uint256 _amount) external returns (uint256 _mintId){
        require(msg.sender == register.getAddress(KUALA_BOND_POOL_CA), "bond pool only");
        _mint(to, _amount);
        _mintId = getIndex();
        mintById[_mintId] = Mint({
                                    id : _mintId, 
                                    amount : _amount,
                                    sentTo : to, 
                                    mintDate : block.timestamp
                                });
        return _mintId; 
    }

    function getMint(uint256 _mintId) view external returns (Mint memory _mint){
        return mintById[_mintId];
    }
    //==================================== INTERNAL ===================================================

    function getIndex() internal returns (uint256 _index){
        _index = index++;
        return _index; 
    }

}
