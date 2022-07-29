// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "../utils/IncentiveId.sol";
import "../interfaces/IUniswapV3Staker.sol";
import {IRegistry} from "../interfaces/IRegistry.sol";
import {IGaugeWrapper} from "../interfaces/IGaugeWrapper.sol";

/// @title Uniswap V3 gauge wrapper.
contract BaseGaugeV2UniV3Wrapper is ReentrancyGuard, IGaugeWrapper {
    address public immutable pool;

    IUniswapV3Staker public override staker;
    IRegistry public immutable override registry;

    constructor(
        address _pool,
        address _registry,
        address _staker
    ) {
        pool = _pool;
        registry = IRegistry(_registry);
        staker = IUniswapV3Staker(_staker);
    }

    function notifyRewardAmount(address token, uint256 amount)
        external
        override
        nonReentrant
    {
        IERC20Minimal _token = IERC20Minimal(token);
        IUniswapV3Staker.IncentiveKey memory key = IUniswapV3Staker.IncentiveKey({
            rewardToken: _token,
            pool: IUniswapV3Pool(pool),
            startTime: block.timestamp,
            endTime: block.timestamp + 7 days,
            refundee: address(0)
        });

        _token.transferFrom(msg.sender, address(this), amount);
        _token.approve(address(staker), amount);
        staker.createIncentive(key, amount);
    }
}
