// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
//Imports
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ZombieFactory {
    //para generar eventos a nivel de web3
    event NewPokemon(uint pokemonId, string name, uint poder);

    uint poderDigits = 16;
    //Nos sirve para limitar el tamaño de la variable poder a 16 digitos
    uint poderModulus = 10 ** poderDigits;

    struct Pokemon {
        string name;
        string tipo;
        uint poder;
    }

    //Array de pokemons
    Pokemon[] public pokemons;

    //Para guardar el dueño de un zombi, vamos a usar dos mapeos: el primero guardará el rastro de la dirección 
    //que posee ese zombi y la otra guardará el rastro de cuantos zombis posee cada propietario.
    mapping (uint => address) public pokemonToOwner;
    mapping (address => uint) ownerPokemonConunt;

    function _createPokemon(string _name, string _tipo, uint _poder) private {
        uint id = pokemons.push(Pokemon(_name, _tipo, _poder)) - 1;
        pokemonToOwner[id]=msg.sender;
        ownerPokemonConunt[msg.sender]++;
        //para generar eventos a nivel de web3
        emit NewPokemon(id, _name, _poder);
    }

    //keccak256 es una version de SHA3 que es una funcion Hash que retorna 256-bits en un formato de numero hexadecimal 
    //que empleamos como pseudo aleatorio, DEBERIAMOS ENCONTRAR UNA MANERA MEJOR 
    function _randomPoder(string _str) private view returns(uint) {
        uint rand = uint(keccak256(_str));
        return rand % poderModulus;
    }

    function createPokemon(string _name) public {
        uint randPoder = _randomPoder(_name);
        _createPokemon(_name, randPoder); 
    }
    
}