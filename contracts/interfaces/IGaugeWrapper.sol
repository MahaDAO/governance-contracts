// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IRegistry} from "./IRegistry.sol";
import {IUniswapV3Staker} from "./IUniswapV3Staker.sol";

interface IGaugeWrapper {
    function notifyRewardAmount(address token, uint256 amount) external;

    function registry() external view returns (IRegistry);

    function staker() external view returns (IUniswapV3Staker);
}
