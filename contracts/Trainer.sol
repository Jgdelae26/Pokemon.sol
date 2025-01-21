// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./Pokemon.sol";

contract Trainer is PokemonFactory{

    struct Entrenador {
        string name;
        uint cuentaVictorias;
        uint cuentaDerrotas;
        uint numPokemons;
    }

    //Array de Entrenadores
    Entrenador[] public entrenadores;

    //Mapping para guardar el nombre del entrenador
    mapping (address => string) public trainerName;
    // Mapeo para rastrear el índice del entrenador en el array
    mapping(address => uint) public addressToEntrenadorIndex;

    //Comprobar que el entrenador está registrado
    modifier registrado(){
        require(bytes(trainerName[msg.sender]).length > 0, "El entrenador no esta registrado");
        _;
    }

    // Evento para registrar al entrenador
    event EntrenadorRegistrado(address indexed entrenadorAddress, string name);
    // Evento para registrar cambio de nombre
    event CambioDeNombre(address indexed entrenadorAddress, string name);
    // Evento para notificar la eliminación del entrenador
    event EntrenadorEliminado(address entrenadorAddress);   

    // Función para registrar un entrenador
    function registrarEntrenador(address _entrenador, string calldata _trainerName) internal{

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
    
    //Función para cambiar nombre de entrenador
    function cambiarNombre(string memory _nuevoNombre) public registrado(){
        // Recuperar el índice del entrenador
        uint index = addressToEntrenadorIndex[msg.sender];
        // Actualizar los mappings de entrenadores
        entrenadores[index].name = _nuevoNombre;
        trainerName[msg.sender] = _nuevoNombre;
        // Emitir evento
        emit CambioDeNombre(msg.sender, _nuevoNombre);
    }

    // Función para consultar los datos de un entrenador
    function consultarEntrenador(address _entrenador) public view registrado() returns (Entrenador memory){
        
        // Recuperar el índice del entrenador
        uint index = addressToEntrenadorIndex[_entrenador];

        // Devolver el entrenador del array
        return entrenadores[index];
    }

    // Función para actualizar las estadísticas de los entrenadores
    function actualizarVictorias(address _entrenador, bool victoria) external registrado() onlyOwner {
        //Recuperar el índice del entrenador
        uint index = addressToEntrenadorIndex[_entrenador];
        //Incrementar las victorias y derrotas en función de la variable booleana "victoria"
        if (victoria) {
            entrenadores[index].cuentaVictorias++;
        } else {
            entrenadores[index].cuentaDerrotas++;
        }
    }
    
    //Consultar el ranking de entrenadores
    function obtenerRanking() public view returns (Entrenador[] memory) {
        Entrenador[] memory rankingEntrenadores = entrenadores; // Creamos una copia del array de entrenadores
        quickSort(rankingEntrenadores, int(0), int(rankingEntrenadores.length - 1)); // Llamamos a QuickSort para ordenar el array
        return rankingEntrenadores; // Devolvemos el array ordenado
    }

    // Función recursiva de QuickSort para ordenar el array(Añadir al contrato de funciones)
    function quickSort(Entrenador[] memory arr, int left, int right) internal pure {
        // Condición base de la recursión: Si el rango de índices es válido (left < right)
        if (left >= right) return;

        // Seleccionamos el pivote: en este caso, el elemento en la posición central
        int pivot = left + (right - left) / 2;
        int i = left;  // Apuntador al inicio del array
        int j = right; // Apuntador al final del array

        Entrenador memory pivotValue = arr[uint(pivot)]; // Guardamos el valor del pivote (el entrenador en esa posición)

        // Comenzamos a recorrer el array desde ambos extremos (i y j) hasta encontrar elementos fuera de lugar
        while (i <= j) {
            // Mover el apuntador i hacia la derecha hasta encontrar un valor mayor que el pivote
            while (arr[uint(i)].cuentaVictorias > pivotValue.cuentaVictorias) i++;

            // Mover el apuntador j hacia la izquierda hasta encontrar un valor menor que el pivote
            while (arr[uint(j)].cuentaVictorias < pivotValue.cuentaVictorias) j--;

            // Si i y j no se han cruzado, intercambiamos los elementos en las posiciones i y j
            if (i <= j) {
                // Intercambiar los elementos de los índices i y j
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);

                // Mover los apuntadores para continuar el proceso
                i++;
                j--;
            }
        }
    }

    function eliminarEntrenador(address _entrenador) external onlyOwner registrado() {
        // Recuperar el índice del entrenador
        uint index = addressToEntrenadorIndex[_entrenador];

        // Verificar que el entrenador tiene Pokémon asociados
        require(entrenadores[index].numPokemons > 0, "El entrenador no tiene Pokemon para eliminar.");

        // Eliminar Pokémones asociados del array y los mapeos
        for (uint i = 0; i < pokemons.length; i++) {
            if (pokemonToOwner[i] == _entrenador) {
                // Eliminar Pokémon del mapeo
                delete pokemonToOwner[i];
                // Limpiar el espacio del Pokémon en el array
                delete pokemons[i];
            }
        }
        // Ajustar el array de Pokémon para compactar
        compactarArrayPokemons();

        // Eliminar el entrenador del array
        uint lastIndex = entrenadores.length - 1;
        if (index != lastIndex) {
            // Mover el último entrenador al lugar del eliminado
            entrenadores[index] = entrenadores[lastIndex];
            // Actualizar el índice en el mapeo para el entrenador movido(se intercambia)
            addressToEntrenadorIndex[_entrenador] = index;
        }
        // Reducir la longitud del array de entrenadores
        entrenadores.pop();

        // Eliminar datos del mapeo
        delete trainerName[_entrenador];
        delete addressToEntrenadorIndex[_entrenador];

        // Emitir evento
        emit EntrenadorEliminado(_entrenador);
    }

    // Función para compactar el array de Pokémon después de eliminaciones
    function compactarArrayPokemons() internal {
        uint originalLength = pokemons.length; // Longitud original del array
        uint newIndex = 0; // Índice para escribir en el array compacto

        for (uint i = 0; i < originalLength; i++) {
            // Si el Pokémon no ha sido eliminado (nombre no vacío)
            if (bytes(pokemons[i].name).length > 0) {
                // Sobrescribir la posición actual con el Pokémon válido
                pokemons[newIndex] = pokemons[i];
                newIndex++; // Incrementar el índice del array compacto
            }
        }

        // Ajustar la longitud del array eliminando los elementos sobrantes
        while (pokemons.length > newIndex) {
            pokemons.pop(); // Eliminar el último elemento del array
        }
    }

}
