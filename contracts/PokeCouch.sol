// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./PokemonFactory.sol";


contract PokeCouch is PokemonFactory {
//Comprueba que el usuario sea el dueño del pokemon
    modifier propietario(uint _pokemonId){
        require(pokemonToOwner[_pokemonId] == msg.sender, "No eres el propietario de este Pokemon.");
        _;
    }
    
    uint randNonce = 0;
    
    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    //Comprueba que el pokemon este recuperado
    function _isReady(Pokemon storage _pokemon) internal view returns (bool) {
        return (_pokemon.readyTime <= block.timestamp);
    }

        //Dispara el timepo de recuperacion de un pokemon
    function _disparadorDeRecu(Pokemon storage _pokemon) internal {
        _pokemon.readyTime = uint32(block.timestamp + tiempoRecu);
    }

    //Funcion para simular batallas pokemon con bots de estats aleatorias 
    function pokeBattleSalvaje(uint _pokemonId) public propietario(_pokemonId) {
        Pokemon storage myPokemon = pokemons[_pokemonId];
        uint statsPoke = myPokemon.ataque + myPokemon.ataqueEspecial + myPokemon.defensa + myPokemon.defensaEspecial + myPokemon.hpPokemon + myPokemon.velocidad;
        require(_isReady(myPokemon));
        uint poderWild = randMod(100000);
        uint _statsWild = _statsWildPokemon(poderWild);
        //si pierdes
        if ( _statsWild >= statsPoke) {
            _disparadorDeRecu(myPokemon);
        } else {
            uint8 indexStat = uint8(poderWild % 10);
            uint8 cantidadSubida = uint8((poderWild/10) % 10);
            _modificacionEstats(myPokemon,indexStat,cantidadSubida );
        }
    }

    /*
    function trainPokemon(uint _pokemonId) private propietario(_pokemonId) {

        // Obtener el Pokémon del jugador
        Pokemon storage pokemon = pokemons[_pokemonId];

        // Aumentar estadísticas de forma aleatoria
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _pokemonId))) % 5;

        Aumento estadísticas
        pokemon.ataque += rand;
        pokemon.defensa += rand;
        pokemon.velocidad += rand;
        pokemon.ataque += rand;
        pokemon.defensa += rand;
        pokemon.hpPokemon += rand;
        
    }
    
    function capturePokemon(uint _enemyId) public {
        // Verificar que el ID del Pokémon sea válido
        require(_enemyId < pokemons.length, "ID de Pokemon invalido.");
        // Verificar que el Pokémon enemigo no pertenece a ningún jugador
        require(pokemonToOwner[_enemyId] == address(0), "Este Pokemon ya pertenece a un entrenador.");

        // Asignar el Pokémon al jugador que lo captura
        pokemonToOwner[_enemyId] = msg.sender;
        ownerPokemonCount[msg.sender]++;
    }
    */
}