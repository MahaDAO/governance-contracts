// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BaseGaugeV2} from "./BaseGaugeV2.sol";
import {IGaugeFactory} from "../interfaces/IGaugeFactory.sol";

contract BaseV2GaugeFactory is IGaugeFactory {
    function createGauge(
        address _pool,
        address _bribe,
        address _registry
    ) external override returns (address) {
        address guage = address(new BaseGaugeV2(_pool, _registry));
        emit GaugeCreated(guage, _pool, _bribe);
        return guage;
    }
}
