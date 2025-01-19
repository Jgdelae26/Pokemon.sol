// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./Pokemon.sol";

contract Trainer is PokemonFactory{

    //Comprobar que el entrenador está registrado
    modifier registrado(){
        require(bytes(trainerName[msg.sender]).length > 0, "El entrenador no esta registrado");
        _;
    }

    // Evento para registrar al entrenador
    event EntrenadorRegistrado(address indexed entrenadorAddress, string name);

    // Función para registrar un entrenador
    function registrarEntrenador(address _entrenador, string calldata _trainerName) external onlyOwner {
        // Verificar si el entrenador ya está registrado
        require(bytes(trainerName[msg.sender]).length == 0, "El entrenador ya esta registrado");

        // Crear un nuevo entrenador y añadirlo al array
        entrenadores.push(Entrenador(_trainerName, 0, 0, 0));

        // Obtener el índice del nuevo entrenador en el array
        uint index = entrenadores.length - 1;

        //Asociacion de la dirección del usuario con el nombre de entrenador que ha escogido
        trainerName[msg.sender] = _trainerName;
        addressToEntrenadorIndex[msg.sender] = index;

        // Emitir evento
        emit EntrenadorRegistrado(msg.sender, _trainerName);
    }
    
    // Función para consultar los datos de un entrenador
    function consultarEntrenador(address _entrenador) public view returns (Entrenador memory) {
        // Verificar si el entrenador no está registrado
        require(bytes(trainerName[msg.sender]).length > 0, "El entrenador no esta registrado");
        
        // Recuperar el índice del entrenador
        uint index = addressToEntrenadorIndex[_entrenador];

        // Devolver el entrenador del array
        return entrenadores[index];
    }

    
}