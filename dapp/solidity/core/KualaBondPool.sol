// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {KualaBond} from "../interfaces/IKualaBondStructs.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol";

import "../interfaces/IKBMintable.sol";
import "../interfaces/IKualaBondContract.sol";
import "../interfaces/IKualaBondPool.sol";
import "../interfaces/IOpsRegister.sol";
import "../interfaces/IVersion.sol";

contract KualaBondPool is IKualaBondPool, IVersion { 

    using Math for uint256; 

    string constant name = "KUALA_BOND_POOL";
    uint256 constant version = 4; 

    address constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    IOpsRegister register; 
    ERC20 erc20;
    ERC20 rewardERC20; 
    address self; 
    uint256 chain; 

    uint256 bondCollateral;
    uint256 liquidity;
    uint256 borrowing; 
    uint256 exitedRewards; 

    uint256 rewardFactorNumerator   = 5; 
    uint256 rewardFactorDenominator = 1000000;
    uint256 rewardFactorPeriod      = 1; 

    uint256 borrowFactorNumerator   = 50; 
    uint256 borrowFactorDenominator = 100; 

    uint256 borrowChargeNumerator = 10; 
    uint256 borrowChargeDenominator = rewardFactorDenominator; 
    uint256 borrowChargePeriod      = 1;  

    uint256 index; 

    mapping(uint256=>Deposit) depositById; 
    mapping(uint256=>Withdraw) withdrawById; 
    mapping(uint256=>bool) isLiquidatedById;
    mapping(uint256=>bool) isWithdrawnByDepositId; 
    mapping(uint256=>bool) isSecurity; 
    mapping(uint256=>bool) isCompleted; 
    mapping(uint256=>Borrow) borrowById; 
    mapping(uint256=>Repayment) repaymentById; 
    mapping(uint256=>LiquidityPush) liquidityPushById; 
    mapping(uint256=>LiquidityPull) liquidityPullById; 
    mapping(uint256=>RewardWithdrawal) rewardWithdrawalById;
    mapping(uint256=>Liquidation) liquidationById; 

    mapping(address=>bool) hasPoolAccount; 
    mapping(address=>PoolAccount) poolAccountByAddress; 

    mapping(address=>mapping(uint256=>bool)) knownBondByBondContract;


    constructor(address _register, uint256 _chainId){
        register    = IOpsRegister(_register);
        erc20       = getERC20(register.getAddress("KB_POOL_TOKEN")); 
        rewardERC20 = getERC20(register.getAddress("KB_POOL_REWARD_TOKEN"));
        self        = address(this);
        chain       = _chainId;
    }

    function getVName() pure  external returns (string memory _name){
        return name; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getERC20() view external returns (ERC20 memory _erc20){
        return erc20; 
    }

    function getRewardERC20() view external returns (ERC20 memory _erc20){
        return rewardERC20; 
    }

    function getPoolStats() view external returns (PoolStats memory _poolStats) {
        return PoolStats({
                            bondCollateral : bondCollateral,
                            liquidity : liquidity, 
                            borrowing : borrowing,
                            exitedRewards : exitedRewards
                        });
    }

    function getPoolAccount() view external returns (PoolAccount memory _poolAccount){
        return poolAccountByAddress[msg.sender];
    }

    function getBorrowing(uint256 _borrowId) view external returns (Borrow memory _borrow){
        return borrowById[_borrowId];
    }

    function getRepayment(uint256 _repaymentId) view external returns (Repayment memory _repayment){
        return repaymentById[_repaymentId];
    }   

    function getDeposit(uint256 _depositId) view external returns (Deposit memory _deposit){
        return depositById[_depositId];
    }

    function getWithdraw(uint256 _withdrawId) view external returns (Withdraw memory _withdraw) {
        return withdrawById[_withdrawId];
    }

    function getRewardsWithdraw(uint256 _rewardsWithdrawId) view external returns (RewardWithdrawal memory _rewardWithdrawal) {
        return rewardWithdrawalById[_rewardsWithdrawId];
    }

    function getLiquidation(uint256 _liquidationId) view external returns (Liquidation memory _liquidation) {
        return liquidationById[_liquidationId];
    }

    function getLiquidityPush(uint256 _liquidityPushId) view external returns (LiquidityPush memory _liquidityPush){
        return liquidityPushById[_liquidityPushId];
    }
    
    function getLiquidityPull(uint256 _liquidityPullId) view external returns (LiquidityPull memory _liquidityPull) {
        return liquidityPullById[_liquidityPullId];
    }

    function getBorrowLimit(uint256 _depositId) view external returns (uint256 _limit){
        return getBorrowLimitInternal(_depositId);
    }

    function borrow(uint256 _depositId, uint256 _amount) external returns (uint256 _borrowId){
        require(!isSecurity[_depositId], "deposit already in use");
        require(depositById[_depositId].owner == msg.sender, "owner mis-match");

        uint256 borrowLimit_ = getBorrowLimitInternal(_depositId);

        require(borrowLimit_ >= _amount, "insufficient borrow limit");
        require(liquidity >= _amount, "insufficient liquidity");

        isSecurity[_depositId] = true; 
        _borrowId = getIndex(); 
        borrowById[_borrowId] = Borrow({ 
                                            id : _borrowId,  
                                            depositId : _depositId, 
                                            amount : _amount,  
                                            settlement : 0,
                                            lastRepaymentDate : 0,
                                            settlementDate : 0, 
                                            chargesSettled : false, 
                                            borrowDate : block.timestamp,
                                            isSettled : false
                                        });
        borrowing += _amount; 
        PoolAccount  storage account_ = poolAccountByAddress[msg.sender]; 
        account_.borrowIds.push(_borrowId);
        transferMoney(self, msg.sender, _amount);
        return _borrowId; 
    }   

    function repay(uint256 _borrowId, uint256 _amount) external returns (uint256 _repaymentId){
        require(!isCompleted[_borrowId], "borrowing repaid");
        require(transferMoney(msg.sender, self, _amount),"transfer failure");
        Borrow storage borrow_ = borrowById[_borrowId];
        uint256 outstanding_ = borrow_.amount - borrow_.settlement; 
        if(outstanding_ <_amount) {
            uint256 refund_ = _amount - outstanding_; 
            require(transferMoney(self, msg.sender, refund_), "surplus refund transfer failed");
        }
        borrow_.settlement += _amount; 
        if(borrow_.settlement == borrow_.amount) {
            isSecurity[borrow_.depositId] = false; 
            isCompleted[_borrowId] = true; 
        }
        _repaymentId = getIndex(); 
        repaymentById[_repaymentId] = Repayment({ 
                                                    id : _repaymentId,  
                                                    borrowId : borrow_.id, 
                                                    amount  : _amount,
                                                    repaymentDate : block.timestamp 
                                                });
        borrowing -= _amount; 
        return _repaymentId; 

    }

    function depositBond(address _bondContract, uint256 _bondId) external returns (uint256 _depositId){
        require(!knownBondByBondContract[_bondContract][_bondId], "already deposited");
        require(transferBond( msg.sender, self, _bondContract, _bondId), "transfer failed");
        knownBondByBondContract[_bondContract][_bondId] = true; 
        _depositId = getIndex();
        Deposit memory deposit_ = Deposit({
                                            id      : _depositId,  
                                            bondId  : _bondId,
                                            bondContract : _bondContract,  
                                            owner : msg.sender, 
                                            depositDate : block.timestamp 
                                        });
        depositById[deposit_.id] = deposit_; 
        bondCollateral += IKualaBondContract(_bondContract).getKualaBond(_bondId).amount; 
        checkAccount();
        PoolAccount  storage account_ = poolAccountByAddress[msg.sender]; 
        account_.depositIds.push(deposit_.id);
        return _depositId; 
    }

    function withdrawBond(uint256 _depositId) external returns (address _bondContract, uint256 _bondId){
        require(!isLiquidatedById[_depositId], "bond liquidated");
        require(!isWithdrawnByDepositId[_depositId], "bond already withdrawn");
        require(!isSecurity[_depositId], "bond still security");

        isWithdrawnByDepositId[_depositId] = true; 
        Deposit memory deposit_ = depositById[_depositId];
        require(msg.sender == deposit_.owner, "bond owner only");

        bondCollateral -= IKualaBondContract(deposit_.bondContract).getKualaBond(deposit_.bondId).amount; 
        uint256 withdrawId_ = getIndex(); 
        withdrawById[withdrawId_] = Withdraw({  
                                                id : withdrawId_,
                                                bondId : deposit_.bondId, 
                                                bondContract : deposit_.bondContract,
                                                owner : msg.sender, 
                                                withdrawDate : block.timestamp 
                                            });
        PoolAccount  storage account_ = poolAccountByAddress[msg.sender]; 
        account_.withdrawIds.push(withdrawId_);
    
        require(transferBond(self, msg.sender, deposit_.bondContract, deposit_.bondId), "transfer failed");
        
        delete knownBondByBondContract[deposit_.bondContract][deposit_.bondId]; 
        bondCollateral -= IKualaBondContract(deposit_.bondContract).getKualaBond(deposit_.bondId).amount; 

        return (deposit_.bondContract, deposit_.bondId);
    }

    function getBorrowCharge(uint256 _borrowId) view external returns (uint256 _totalBorrowCharge) {
        return getBorrowChargeInternal(_borrowId);
    }





    function getRewards() view external returns (uint256 _totalCurrentRewards){
        require(hasPoolAccount[msg.sender], "no account");
        PoolAccount memory account_ = poolAccountByAddress[msg.sender];
        for(uint256 x = 0; x < account_.liquidityPushIds.length; x++) {
            _totalCurrentRewards += getRewardInternal(account_.liquidityPushIds[x]);
        }
    }

    function withdrawRewards(uint256 _liquidityPushId) external returns (uint256 _rewardWithdrawalId){
        LiquidityPush storage lp_ = liquidityPushById[_liquidityPushId];
        require(lp_.owner == msg.sender, "owner only");
        require(!lp_.allRewardsIssued, "all rewards issued");
        _rewardWithdrawalId = getIndex(); 
        uint256 rewards_ = getRewardInternal(_liquidityPushId);
        if(lp_.isPulled){
            lp_.allRewardsIssued = true; 
        }
        transferRewards(msg.sender, rewards_);
        rewardWithdrawalById[_rewardWithdrawalId] =  RewardWithdrawal({ 
                                                                        id : _rewardWithdrawalId,
                                                                        liquidityPushId : _liquidityPushId,  
                                                                        amount : rewards_, 
                                                                        owner : msg.sender,  
                                                                        withdrawalDate : block.timestamp 
                                                                    });
        exitedRewards += rewards_; 
        return _rewardWithdrawalId; 
    }

    function pushLiquidity(uint256 _amount) external payable returns (uint256 _liquidityPushId){
        if(erc20.token == NATIVE) {
            require(msg.value >= _amount, "insufficient liquidity pushed");
        }
        else {
            require(transferMoney(msg.sender, self, _amount),"transfer failure");
        }
        checkAccount(); 
        _liquidityPushId = getIndex(); 
         PoolAccount storage account_ = poolAccountByAddress[msg.sender]; 
        account_.liquidityPushIds.push(_liquidityPushId);
        liquidityPushById[_liquidityPushId] = LiquidityPush({
                                                                id : _liquidityPushId, 
                                                                amount : _amount,
                                                                owner : msg.sender, 
                                                                pushDate : block.timestamp,
                                                                lastRewardDrawdownDate : 0,
                                                                liquidityPullDate : 0, 
                                                                isPulled : false,
                                                                allRewardsIssued : false
                                                            });
        liquidity += _amount; 
        return _liquidityPushId; 
    }

    function pullLiquidity(uint256 _liquidityPushId) external returns (uint256 _liquidityPullId){
        LiquidityPush storage liquidityPush_ = liquidityPushById[_liquidityPushId];
        require(liquidityPush_.owner == msg.sender, "liquidity push owner mis-match");
        liquidity -= liquidityPush_.amount; 
        liquidityPush_.isPulled = true; 
        _liquidityPullId = getIndex(); 
        if(erc20.token == NATIVE){
            payable(liquidityPush_.owner).transfer(liquidityPush_.amount);
        }
        else {
            require(transferMoney(self, msg.sender, liquidityPush_.amount), "transfer failure");
        }
        liquidityPullById[_liquidityPullId] = LiquidityPull({
                                                                id : _liquidityPullId, 
                                                                amount : liquidityPush_.amount,
                                                                owner : msg.sender, 
                                                                pullDate : block.timestamp 
                                                            });
        return _liquidityPullId; 
    }

    function getTotalPushedLiquidity() view external returns (uint256 _amount){
        return liquidity; 
    }
    
    // ================================ INTERNAL =======================================================
    function getBorrowLimitInternal(uint256 _depositId) view internal returns (uint256 _limit) {
        Deposit memory deposit_ = depositById[_depositId];
        uint256 depositAmount_ = IKualaBondContract(deposit_.bondContract).getKualaBond(deposit_.bondId).amount; 
        bool success_ = false; 
        (success_, _limit)= (borrowFactorNumerator * depositAmount_).tryDiv(borrowFactorDenominator);
        return success_? _limit : 0;
    }
    
    function checkAccount() internal returns (bool _success) {
        if(!hasPoolAccount[msg.sender]){
            poolAccountByAddress[msg.sender] = PoolAccount({
                                                                depositIds : new uint256[](0), 
                                                                withdrawIds : new uint256[](0), 
                                                                borrowIds : new uint256[](0), 
                                                                repaymentIds : new uint256[](0),
                                                                liquidityPushIds : new uint256[](0),
                                                                liquidityPullIds : new uint256[](0),
                                                                rewardWithdrawalIds : new uint256[](0),
                                                                liquidationIds : new uint256[](0)
                                                            });
        }
        return true; 
    }
   
    function transferBond(address _from, address _to, address _bondContract, uint256 _bondId) internal returns (bool _success) {
        IERC721 erc721_ = IERC721(_bondContract);
        erc721_.transferFrom(_from, _to, _bondId);
        return true; 
    }

    function transferMoney(address _from, address _to, uint256 _amount) internal returns (bool _success) {
        IERC20 erc20_ = IERC20(erc20.token);
        erc20_.transferFrom(_from, _to, _amount);
        return true; 
    } 

    function transferRewards(address _to, uint256 _amount) internal returns (bool _success) {
        IKBMintable mintable_ = IKBMintable(rewardERC20.token);
        mintable_.mint(_to, _amount);
        return true; 
    } 

    function getERC20(address _erc20Address) view internal returns (ERC20 memory _erc20) {
        IERC20Metadata ierc20_ = IERC20Metadata(_erc20Address);
        return ERC20({
                        name : ierc20_.name(), 
                        symbol : ierc20_.symbol(),  
                        token : _erc20Address, 
                        chainId : chain
                    });
    }

    function getBorrowChargeInternal(uint256 _borrowId) view internal returns (uint256 _charge) {
        Borrow memory borrow_ = borrowById[_borrowId];
        if(borrow_.isSettled && borrow_.chargesSettled) {
            return 0; 
        }
        uint256 end_ = (borrow_.settlementDate == 0)? block.timestamp : borrow_.settlementDate;  
        uint256 start_ = (borrow_.lastRepaymentDate == 0)? borrow_.borrowDate : borrow_.lastRepaymentDate;
        uint256 amount_ = borrow_.amount - borrow_.settlement; 
        return calculateIssue(start_, end_, amount_, borrowChargeNumerator, borrowChargeDenominator);
    }

    function getRewardInternal(uint256 _liquidityPushId) view internal returns (uint256 _reward) {
        LiquidityPush memory lp_ = liquidityPushById[_liquidityPushId];
        if(lp_.isPulled && lp_.allRewardsIssued){
           return 0;  
        }
        uint256 end_ = (lp_.isPulled? lp_.liquidityPullDate : block.timestamp);
        uint256 start_ = (lp_.lastRewardDrawdownDate == 0)?lp_.pushDate : lp_.lastRewardDrawdownDate;
        return calculateIssue(start_, end_, lp_.amount, rewardFactorNumerator, rewardFactorDenominator); 
    }

    function calculateIssue(uint256 _start, uint256 _end, uint256 _amount, uint256 _numerator, uint256 _denominator) pure internal returns (uint256 _issue) {
        uint256 time_ = _end - _start; 
        bool success_ = false; 
        uint256 _rewardPerTime = 0;
        (success_, _rewardPerTime) = (_amount * _numerator).tryDiv(_denominator);
        _issue = (success_?_rewardPerTime : 0) * time_; 
        return _issue; 
    }

    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }

}