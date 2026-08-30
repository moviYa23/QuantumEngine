// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MoviyangToken is ERC20, Ownable {
    constructor() ERC20("Moviyang Token", "MOVY") {}

    // Mint automático por compra: solo callable por la backend wallet (setear rol)
    function mintForPurchase(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
