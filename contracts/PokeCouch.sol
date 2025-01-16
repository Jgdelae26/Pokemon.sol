// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./Pokemon.sol";

contract PokeCouch is PokemonFactory {

  //function feed(uint pokeId)   public {
  //  require(msg.sender == pokemonToOwner[pokeId]);
  //}

  function battle(uint _pokemonId) view public {
    // Verificar que el ID del Pokémon sea válido
    require(_pokemonId < pokemons.length, "ID de Pokemon invalido.");
    // Verificar que el Pokémon pertenece al usuario que llama
    require(pokemonToOwner[_pokemonId] == msg.sender, "No eres el propietario de este Pokemon.");

    // Obtener el Pokémon del jugador
    Pokemon storage pokemonJugador = pokemons[_pokemonId];

    // Generar un Pokémon enemigo aleatorio
    string memory nombreEnemigo = "PokemonSalvaje";
    uint poderEnemigo = pokemon._randomPoder("Enemigo");
    uint ataqueEnemigo = poderEnemigo % 10;
    uint defensaEnemigo = (poderEnemigo / 10) % 10;
    uint velocidadEnemigo = (poderEnemigo / 100) % 10;
  }
}