// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
//Imports
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ZombieFactory {
    //para generar eventos a nivel de web3
    event NewPokemon(uint pokemonId, string name, uint poder);

    uint poderDigits = 5;
    //Nos sirve para limitar el tamaño de la variable poder a 16 digitos
    uint poderModulus = 10 ** poderDigits;

    struct Pokemon {
        string name;
        string elemento;
        uint ataque;
        uint defensa;
        uint ataqueEspecial;
        uint defensaEspecial;
        uint velocidad;
    }

    //Array de pokemons
    Pokemon[] public pokemons;

    //Para guardar el dueño de un zombi, vamos a usar dos mapeos: el primero guardará el rastro de la dirección 
    //que posee ese zombi y la otra guardará el rastro de cuantos zombis posee cada propietario.
    mapping (uint => address) public pokemonToOwner;
    mapping (address => uint) ownerPokemonConunt;

    //Mapping para guardar el nombre del entrenador
    mapping (address => string) public trainerName;

    function _createPokemon(string memory _name, string memory _elemento, uint  _poder, string calldata _trainerName) private {
        uint ataque = _poder % 10;
        uint defensa = (_poder/10) % 10;
        uint ataqueEspecial = (_poder/100) % 10;
        uint defensaEspecial = (_poder/1000) % 10;
        uint velocidad= (_poder/10**4) % 10;
        pokemons.push(Pokemon(_name, _elemento, ataque, defensa, ataqueEspecial, defensaEspecial, velocidad));
        uint id = pokemons.length - 1;
        pokemonToOwner[id]=msg.sender;
        ownerPokemonConunt[msg.sender]++;
        trainerName[msg.sender]=_trainerName;
        //para generar eventos a nivel de web3
        emit NewPokemon(id, _name, _poder);
    }

    //keccak256 es una version de SHA3 que es una funcion Hash que retorna 256-bits en un formato de numero hexadecimal 
    //que empleamos como pseudo aleatorio, DEBERIAMOS ENCONTRAR UNA MANERA MEJOR 
    function _randomPoder(string calldata _str) private view returns(uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % poderModulus;
    }

    function processElement(string memory _element) public pure returns (string memory) {
        bytes32 elementHash = keccak256(abi.encodePacked(_element));

        if (elementHash == keccak256(abi.encodePacked("Agua"))) {
            return "Aqualis";
        } else if (elementHash == keccak256(abi.encodePacked("Fuego"))) {
            return "Ignis";
        } else if (elementHash == keccak256(abi.encodePacked("Tierra"))) {
            return "Terranox";
        } else {
            revert("Elemento no valido. Solo se aceptan 'Agua', 'Fuego' o 'Tierra'.");
        }
    }

    function createPokemon(string memory _elemento, string calldata _trainerName) public {
        require(ownerPokemonConunt[msg.sender] == 0);
        uint randPoder = _randomPoder(_trainerName);
         string memory name = processElement(_elemento);
        _createPokemon(name, _elemento, randPoder, _trainerName); 
    }
    
}