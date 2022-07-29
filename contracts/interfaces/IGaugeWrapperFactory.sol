// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IGaugeWrapperFactory {
  function createGauge(
    address _registry,
    address _pool,
    address _bribe,
    address _uniV3Staker
  ) external returns (address);

  event GaugeCreated(address _gauge, address _pool, address _bribe, address _uniV3Staker);
}
