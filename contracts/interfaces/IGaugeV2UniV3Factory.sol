// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IGaugeV2UniV3Factory {
  function createGauge(
    address _pool,
    address _bribe,
    address _registry,
    address _uniswapV3factory,
    address _nonfungiblePositionManager,
    uint256 _maxIncentiveStartLeadTime,
    uint256 _maxIncentiveDuration
  ) external returns (address);

  event GaugeCreated(
    address _gauge,
    address _pool,
    address _bribe,
    address _registry,
    address _uniswapV3factory,
    address _nonfungiblePositionManager,
    uint256 _maxIncentiveStartLeadTime,
    uint256 _maxIncentiveDuration
  );
}
