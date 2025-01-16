// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./Pokemon.sol";

contract PokeCouch is PokemonFactory {

  //function feed(uint pokeId)   public {
  //  require(msg.sender == pokemonToOwner[pokeId]);
  //}

  // Función para listar los Pokémon de un entrenador
  function _listPokemons() public view returns (Pokemon[] memory) {
    uint cantidad = ownerPokemonCount[msg.sender];
    require(cantidad > 0, "No posees ningun Pokemon.");

    // Crear arrays temporales para devolver los datos
    Pokemon[] memory misPokemon = new Pokemon[](cantidad);

    uint contador = 0;
      for (uint i = 0; i < pokemons.length; i++) {
          if (pokemonToOwner[i] == msg.sender) {
              misPokemon[contador] = pokemons[i];
              contador++;
          }
      }
    return (misPokemon);
  }

  function battle(uint _pokemonId) view  public {
    // Verificar que el ID del Pokémon sea válido
    require(_pokemonId < pokemons.length, "ID de Pokemon invalido.");
    // Verificar que el Pokémon pertenece al usuario que llama
    require(pokemonToOwner[_pokemonId] == msg.sender, "No eres el propietario de este Pokemon.");
  }
}