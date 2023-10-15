// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "./IKualaBondStructs.sol";

struct PoolAccount { 
    uint256 [] depositIds; 
    uint256 [] withdrawIds; 
    uint256 [] borrowIds; 
    uint256 [] repaymentIds; 
    uint256 [] liquidityPushIds; 
    uint256 [] liquidityPullIds;
    uint256 [] rewardWithdrawalIds;
    uint256 [] liquidationIds; 
}

struct Deposit { 
    uint256 id; 
    uint256 bondId; 
    address bondContract; 
    address owner; 
    uint256 depositDate; 
}

struct Withdraw { 
    uint256 id; 
    uint256 bondId; 
    address bondContract; 
    address owner; 
    uint256 withdrawDate; 
}

struct Borrow { 
    uint256 id; 
    uint256 depositId; 
    uint256 amount;
    uint256 settlement;
    uint256 lastRepaymentDate;
    uint256 settlementDate; 
    bool chargesSettled; 
    uint256 borrowDate;
    bool isSettled;  
}

struct Repayment { 
    uint256 id; 
    uint256 borrowId; 
    uint256 amount; 
    uint256 repaymentDate; 
}

struct LiquidityPush { 
    uint256 id; 
    uint256 amount; 
    address owner; 
    uint256 pushDate; 
    uint256 lastRewardDrawdownDate; 
    uint256 liquidityPullDate; 
    bool isPulled; 
    bool allRewardsIssued; 
}

struct LiquidityPull { 
    uint256 id; 
    uint256 amount; 
    address owner; 
    uint256 pullDate; 
}

struct RewardWithdrawal { 
    uint256 id;
    uint256 liquidityPushId; 
    uint256 amount; 
    address owner; 
    uint256 withdrawalDate; 
}

struct Liquidation { 
    uint256 id; 
    uint256 amount; 
    uint256 deposit; 
    uint256 liquidationDate; 
}

struct PoolStats { 
    uint256 bondCollateral;
    uint256 liquidity;
    uint256 borrowing; 
    uint256 exitedRewards; 
}

interface IKualaBondPool { 
    
    function getERC20() view external returns (ERC20 memory _erc20);

    function getRewardERC20() view external returns (ERC20 memory _erc20);

    function getPoolStats() view external returns (PoolStats memory _poolStats);

    function getPoolAccount() view external returns (PoolAccount memory _poolAccount);

    function getBorrowing(uint256 _borrowId) view external returns (Borrow memory _borrow);

    function getRepayment(uint256 _repaymentId) view external returns (Repayment memory _repayment);

    function getDeposit(uint256 _depositId) view external returns (Deposit memory _deposit);

    function getWithdraw(uint256 _withdrawId) view external returns (Withdraw memory _withdraw);

    function getRewardsWithdraw(uint256 _rewardsWithdrawId) view external returns (RewardWithdrawal memory _rewardWithdrawal);

    function getLiquidation(uint256 _liquidationId) view external returns (Liquidation memory _liquidation);

    function getLiquidityPush(uint256 _liquidityPushId) view external returns (LiquidityPush memory _liquidityPush);

    function getLiquidityPull(uint256 _liquidityPullId) view external returns (LiquidityPull memory _liquidityPull);
    
    function borrow(uint256 _depositId, uint256 _amount) external returns (uint256 _borrowId);

    function repay(uint256 _borrowId, uint256 _amount) external returns (uint256 _repaymentId);

    function getBorrowLimit(uint256 _depositId) view external returns (uint256 _limit);

    function depositBond(address _bondContract, uint256 _bondId) external returns (uint256 _depositId);

    function withdrawBond(uint256 _depositId) external returns (address _bondContract, uint256 _bondId);

    function getRewards() view external returns (uint256 _totalCurrentRewards);

    function withdrawRewards(uint256 _liquidityPushId) external returns (uint256 _rewardsWithdrawalId);

    function pushLiquidity(uint256 _amount) external payable returns (uint256 _liquidityPushid);

    function pullLiquidity(uint256 _liquidityPusId) external returns (uint256 _liquidityPullId);

    function getTotalPushedLiquidity() view external returns (uint256 _amount);
}