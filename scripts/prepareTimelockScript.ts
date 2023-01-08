import {
  impersonateAccount,
  setBalance,
} from "@nomicfoundation/hardhat-network-helpers";
import { time } from "console";
import { ethers, network } from "hardhat";

async function main() {
  console.log(`Deploying to ${network.name}...`);

  // const [deployer] = await ethers.getSigners();
  const deployer = await ethers.getSigner(
    "0x6357EDbfE5aDA570005ceB8FAd3139eF5A8863CC"
  );
  await impersonateAccount(deployer.address);
  await setBalance(deployer.address, "0x8AC7230489E80000");
  console.log(`Deployer address is ${deployer.address}.`);

  const timelock = await ethers.getContractAt(
    "MAHATimelockController",
    "0xd9333e02a4d85611d0f0498b858b2ae3c29de6fb"
  );

  // grant proposer and executor roles
  await timelock
    .connect(deployer)
    .grantRole(await timelock.EXECUTOR_ROLE(), deployer.address);
  await timelock
    .connect(deployer)
    .grantRole(await timelock.PROPOSER_ROLE(), deployer.address);

  const execute: [string, number, string, string, string] = [
    "0x8cc0f052fff7ead7f2edcccac895502e884a8a71", // address target, arth
    0, // uint256 value
    "0xf2fde38b0000000000000000000000006357EDbfE5aDA570005ceB8FAd3139eF5A8863CC", // bytes calldata data, transferOwnership
    "0x3bea49a617a7a55669003cbba150816d681e9d895026257ac71dde85b775a1fe", // bytes32 predecessor,
    "0x724e78da000000000000000000000000cb056c17ce063f20a8d0650f30550b20", // bytes32 salt,
  ];

  console.log(`creating timelock tx...`);
  const hash = await timelock.hashOperation(
    execute[0],
    execute[1],
    execute[2],
    execute[3],
    execute[4]
  );
  console.log(hash);

  const tx = await timelock.connect(deployer).schedule(
    execute[0],
    execute[1],
    execute[2],
    execute[3],
    execute[4],
    1036800 // uint256 delay
  );
  console.log(`tx ${tx.hash}`);

  console.log("is pending?", await timelock.isOperationPending(hash));
  console.log("is done?", await timelock.isOperationDone(hash));
  console.log("is ready?", await timelock.isOperationReady(hash));

  // wait for 12 days
  // suppose the current block has a timestamp of 01:00 PM
  await network.provider.send("evm_setNextBlockTimestamp", [
    Math.floor(new Date("2023-09-01T00:00:00.000Z").getTime() / 1000),
  ]);
  await network.provider.send("evm_mine"); // this one will have 02:00 PM as its timestamp

  console.log("is pending?", await timelock.isOperationPending(hash));
  console.log("is done?", await timelock.isOperationDone(hash));
  console.log("is ready?", await timelock.isOperationReady(hash));

  // execute the tx
  const tx2 = await timelock
    .connect(deployer)
    .execute(execute[0], execute[1], execute[2], execute[3], execute[4]);
  console.log(`tx2 ${tx2.hash}`);

  // now check whatever we want here
  const arth = await ethers.getContractAt("Ownable", execute[0]);
  console.log("owner", await arth.owner());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
