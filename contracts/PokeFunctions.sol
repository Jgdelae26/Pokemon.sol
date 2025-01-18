// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./PokeCouch.sol";

contract PokeFunctions is PokeCouch {

    //Función para ver los poquemons que tiene una direccion en concreto. No es la forma que seria mas practica pero si la mas eficiente, ya que
    // trabajamos con un array nuevo de tipo memory y no modificamos ningun array de los que tenemos en storage directamente entonces este array en memory se 
    //creara cada vez que se llame la funcion y se recorrera el array en storage buscando los pokemon de la direeccion. Poco eficiente pero barat.
    //Mejor explicado en https://cryptozombies.io/es/lesson/3/chapter/12
    function getPokemonByOwner(address _owner) external view returns(uint[] memory) {
      uint[] memory result = new uint[](ownerPokemonCount[_owner]);
      uint counter = 0;
      for (uint i = 0; i < pokemons.length; i++) {
        if (pokemonToOwner[i] == _owner) {
          result[counter] = i;
          counter++;
        }
      }
    return result;
  }

  
}