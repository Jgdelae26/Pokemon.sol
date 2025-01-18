// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./Pokemon.sol";

contract PokeCouch is PokemonFactory {
  

  //function feed(uint pokeId)   public {
  //  require(msg.sender == pokemonToOwner[pokeId]);
  //}

  function battle(uint _pokemonId) public {
    // Verificar que el ID del Pokémon sea válido
    require(_pokemonId < pokemons.length, "ID de Pokemon invalido.");
    // Verificar que el Pokémon pertenece al usuario que llama
    require(pokemonToOwner[_pokemonId] == msg.sender, "No eres el propietario de este Pokemon.");

    // Obtener el Pokémon del jugador
    Pokemon storage pokemonJugador = pokemons[_pokemonId];

    // Crear el Pokémon enemigo
    createEnemyPokemon();
    
    // Obtener el Pokémon enemigo
    uint idEnemigo = pokemons.length - 1;
    Pokemon storage pokemonEnemigo = pokemons[idEnemigo];

    // Inicializamos puntos de salud (HP)
    uint hpJugador = pokemonJugador.hpPokemon;
    uint hpEnemigo = pokemonEnemigo.hpPokemon;

    // Simular el combate
    while (hpJugador > 0 && hpEnemigo > 0) {
        // Turno del jugador
        if (pokemonJugador.velocidad >= pokemonEnemigo.velocidad) {
            uint damageJugador = (pokemonJugador.ataque + pokemonJugador.ataqueEspecial) / 2;
            hpEnemigo = hpEnemigo > damageJugador ? hpEnemigo - damageJugador : 0;

            // Verificar si el enemigo ha sido derrotado
            if (hpEnemigo == 0) {
                // El jugador ha ganado, eliminamos al Pokémon enemigo
                _removePokemon(idEnemigo);
                return;
            }

            // Turno del enemigo
            uint damageEnemigo = (pokemonEnemigo.ataque + pokemonEnemigo.ataqueEspecial) / 2;
            hpJugador = hpJugador > damageEnemigo ? hpJugador - damageEnemigo : 0;

            // Verificar si el jugador ha sido derrotado
            if (hpJugador == 0) {
                return;
            }
        } else {
            // Turno del enemigo primero
            uint damageEnemigo = (pokemonEnemigo.ataque + pokemonEnemigo.ataqueEspecial) / 2;
            hpJugador = hpJugador > damageEnemigo ? hpJugador - damageEnemigo : 0;

            // Verificar si el jugador ha sido derrotado
            if (hpJugador == 0) {
                return;
            }

            // Turno del jugador
            uint damageJugador = (pokemonJugador.ataque + pokemonJugador.ataqueEspecial) / 2;
            hpEnemigo = hpEnemigo > damageJugador ? hpEnemigo - damageJugador : 0;

            // Verificar si el enemigo ha sido derrotado
            if (hpEnemigo == 0) {
                // El jugador ha ganado, eliminamos al Pokémon enemigo
                _removePokemon(idEnemigo);
                return;
            }
        }
    }
  }

    function trainPokemon(uint _pokemonId) public {
        // Verificar que el ID del Pokémon sea válido
        require(_pokemonId < pokemons.length, "ID de Pokemon invalido.");
        // Verificar que el Pokémon pertenece al usuario que llama
        require(pokemonToOwner[_pokemonId] == msg.sender, "No eres el propietario de este Pokemon.");

        // Obtener el Pokémon del jugador
        Pokemon storage pokemon = pokemons[_pokemonId];

        // Aumentar estadísticas de forma aleatoria
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _pokemonId))) % 5;

        //Aumento estadísticas
        pokemon.ataque += rand;
        pokemon.defensa += rand;
        pokemon.velocidad += rand;
        pokemon.ataque += rand;
        pokemon.defensa += rand;
        pokemon.hpPokemon += rand;
    }

    function capturePokemon(uint _enemyId) public {
            
    }
}