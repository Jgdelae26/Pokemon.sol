// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./PokeFunctions.sol";

contract PokeBattles is PokeFunctions {
    uint randNonce = 0;
    
    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }
}