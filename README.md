# MahaDAO Governance Contracts

This repository contains the smart-contracts that are responsible for MahaDAO's governance. This includes voting, staking, gauges and pool incentives.

- [Registry.sol](./contracts/Registry.sol): This contract holds the addresses of all the deployed contracts and is referenced by the various components. [Etherscan](https://etherscan.io/address/0x2684861ba9dada685a11c4e9e5aed8630f08afe0)
- [MAHAXLocker.sol](./contracts/MAHAXLocker.sol): This contract locks MAHA and mints a NFT for every lock. [Etherscan](https://etherscan.io/address/0xbdD8F4dAF71C2cB16ccE7e54BB81ef3cfcF5AAcb)
- [MAHAXStaker.sol](./contracts/MAHAXStaker.sol): This contract tracks votes for every address whenever a user stakes his/her NFT. [Etherscan](https://etherscan.io/address/0x608917F8392634428Ec71C6766F3eC3f5cc8f421)
- [MAHAXGovernor.sol](./contracts/MAHAXGovernor.sol): Openzepplin's governor contract that creates and executes proposals. [Etherscan](https://etherscan.io/address/0xffec018583152ab5f056c5323f1f68b701bf1bc5)
- [BaseV2Voter.sol](./contracts/voter/BaseV2Voter.sol): This contract is responsible for tracking votes for every address. [Etherscan](https://etherscan.io/address/0xFbbe448D38231c298E9A2251bc0c567543e2ccA6)
- [LockMigrator.sol](./contracts/LockMigrator.sol): A migrator contract with permissions to mint NFTs that match a merkle proof. [Etherescan](https://etherscan.io/address/0xb180B2e4821e99a69d19f0845D2cc572eA412481)

## Deployment Instructions

For deployment to mainnet run the following script.

```
yarn install
yarn compile
npx hardhat run scripts/mainnet/deploy.ts --network <network>
```

You'd need to keep a file in the `./deployments/<network>.json` folder with all ERC20 token addresses that you'll use. See [`template.json`](./deployments/template.json) for a reference on what to start with.

Also keep a `.env` file with values mentioned in the [`.env.example`](./.env.example) file.

# Contracts Overview

The governance contracts was built keeping in mind security and upgradability for future robustness of the governance. In this section we describe what each contracts does and if there's any special attention that should be given to it.

## Registry.sol

This contract maintains the registry of all contract addresses. It used to allow for an easy way of upgrading the various components of the govenrance. In the event there is a bug or one of the contract needs to be upgraded, an update to the `Registry` will update the reference for all the other currently deployed contracts.

The contracts contains functionality to pause governance by an address that has the `EMERGENCY_STOP_ROLE` role. This is used in the unlikely event that governance itself has been compromised and the protocol needs to wind down.

The registry maintains the a reference to the following contracts:

[Source Code](./contracts/Regsitry.sol) - [Etherscan](https://etherscan.io/address/0x2684861ba9dada685a11c4e9e5aed8630f08afe0)
