// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./Pokemon.sol";

contract Trainer is PokemonFactory{
    // Función para registrar un entrenador
    function registrarEntrenador(address _entrenador, string calldata _name) external onlyOwner {

    }
}