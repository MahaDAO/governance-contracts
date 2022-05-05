// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
  // solhint-disable-next-line
  constructor(string memory name, string memory symbol) ERC20(name, symbol) {

  }

  function mint(address account, uint256 amount) public {
    _mint(account, amount);
  }
}
