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
    // Evento para registrar cambio de nombre
    event CambioDeNombre(address indexed entrenadorAddress, string name);

    // Función para registrar un entrenador
    function registrarEntrenador(address _entrenador, string calldata _trainerName) external{
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
    
    //Función para cambiar nombre de entrenador
    function cambiarNombre(string memory _nuevoNombre) public registrado(){
        // Recuperar el índice del entrenador
        uint index = addressToEntrenadorIndex[msg.sender];
        // Actualizar los mappings de entrenadores
        entrenadores[index].name = _nuevoNombre;
        trainerName[msg.sender] = _nuevoNombre;
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


}