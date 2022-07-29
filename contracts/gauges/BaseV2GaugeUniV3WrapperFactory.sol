// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BaseGaugeV2UniV3Wrapper} from "./BaseGaugeV2UniV3Wrapper.sol";
import {IGaugeWrapperFactory} from "../interfaces/IGaugeWrapperFactory.sol";

contract BaseV2GaugeUniV3WrapperFactory is IGaugeWrapperFactory {
    function createGauge(
        address _pool,
        address _bribe,
        address _registry,
        address _uniV3Staker
    ) external override returns (address) {
        address guage = address(new BaseGaugeV2UniV3Wrapper(_pool, _registry, _uniV3Staker));
        emit GaugeCreated(guage, _pool, _bribe, _uniV3Staker);
        return guage;
    }
}
