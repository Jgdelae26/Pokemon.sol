// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./Pokemon.sol";

contract Trainer is PokemonFactory{
    // Función para registrar un entrenador
    function registrarEntrenador(address _entrenador, string calldata _trainerName) external onlyOwner {
        // Verificar si el entrenador ya está registrado
        require(bytes(trainerName[msg.sender]).length == 0, "El entrenador ya esta registrado");

        // Crear un nuevo entrenador y añadirlo al array
        entrenadores.push(Entrenador(_trainerName, 0, 0, 0));
    }
}