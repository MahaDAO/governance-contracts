// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IGovernorTimelock} from "@openzeppelin/contracts/governance/extensions/IGovernorTimelock.sol";
import {INonfungiblePositionManager} from "../../interfaces/INonfungiblePositionManager.sol";
import {StakingRewardsV3} from "./StakingRewardsV3.sol";

contract BaseGaugeV3UniV3 is StakingRewardsV3 {
    /// @dev is the contract in emergency mode? if so then allow for NFTs to be withdrawn without much checks.
    bool public inEmergency;

    constructor(
        address _token0,
        address _token1,
        uint24 _fee,
        address _registry,
        INonfungiblePositionManager _nonfungiblePositionManager
    )
        StakingRewardsV3(
            _token0,
            _token1,
            _fee,
            _registry,
            _nonfungiblePositionManager
        )
    {}

    function onERC721Received(
        address,
        address _from,
        uint256 _tokenId,
        bytes calldata
    ) external returns (bytes4) {
        require(inEmergency, "not in emergency mode");
        _onERC721Received(_from, _tokenId);
        return this.onERC721Received.selector;
    }

    function withdrawViaEmergency(uint256 _tokenId)
        external
        nonReentrant
        onlyTokenOwner(_tokenId)
    {
        require(inEmergency, "not in emergency mode");
        require(deposits[_tokenId].liquidity != 0, "stake does not exist");

        delete deposits[_tokenId];
        emit Withdrawn(msg.sender, _tokenId);

        nonfungiblePositionManager.safeTransferFrom(
            address(this),
            msg.sender,
            _tokenId
        );
    }

    function enableEmergencyMode() external onlyTimelock {
        require(!inEmergency, "already in emergency mode");
        inEmergency = true;
        rewardsToken.transfer(
            msg.sender,
            rewardsToken.balanceOf(address(this))
        );

        emit EmergencyModeEnabled();
    }

    /// @dev in case admin needs to execute some calls directly
    function emergencyCall(address target, bytes memory signature)
        external
        onlyTimelock
    {
        require(inEmergency, "not in emergency mode");
        (bool success, bytes memory response) = target.call(signature);
        require(success, string(response));
    }

    modifier onlyTimelock() {
        require(
            msg.sender == IGovernorTimelock(registry.governor()).timelock(),
            "not timelock"
        );
        _;
    }
}