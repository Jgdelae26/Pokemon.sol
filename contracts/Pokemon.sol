// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
//Imports
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract PokemonFactory is Ownable{
    
    constructor() Ownable(msg.sender) { 
    
    }
    
    //para generar eventos a nivel de web3
    event NewPokemon(uint pokemonId, string name, uint poder);

    uint poderDigits = 5;
    //Nos sirve para limitar el tamaño de la variable poder a 16 digitos
    uint poderModulus = 10 ** poderDigits;
    //Tiempode enfriamiento para las derrotas ()
    uint tiempoRecu = 1 days;

    struct Pokemon {
        string name;
        string elemento;
        uint readyTime;
        uint8 level;
        //uint8 para obtimizar los costes de gas tenemos 256 maximo
        uint8 ataque;
        uint8 defensa;
        uint8 ataqueEspecial;
        uint8 defensaEspecial;
        uint8 velocidad;
    }

    struct Entrenador {
        string name;
        uint cuentaVictorias;
        uint cuentaDerrtas;
        uint numPokemons;
    }
    
    //Array de Entrenadores
    Entrenador[] public entrenadores;

    //Array de pokemons
    Pokemon[] public pokemons;

    //Para guardar el dueño de un pokemon, vamos a usar dos mapeos: el primero guardará el rastro de la dirección 
    //que posee ese pokemon y la otra guardará el rastro de cuantos pokemon posee cada propietario.
    mapping (uint => address) public pokemonToOwner;
    mapping (address => uint) ownerPokemonCount;

    //Mapping para guardar el nombre del entrenador
    mapping (address => string) public trainerName;

    //Funcion principal para crear pokemons arraigados a un entrenador
    function _createPokemon(string memory _name, string memory _elemento, uint  _poder, string calldata _trainerName) private {
        //Tratamiento de los stats en funcion de la var aleatoria poder
        uint ataque = _poder % 10;
        uint defensa = (_poder/10) % 10;
        uint ataqueEspecial = (_poder/100) % 10;
        uint defensaEspecial = (_poder/1000) % 10;
        uint velocidad= (_poder/10**4) % 10;
        uint hpPokemon = 50 + defensa * 2;
        //Se aumenta el array de Pokemon
        pokemons.push(Pokemon(_name, _elemento, hpPokemon, ataque, defensa, ataqueEspecial, defensaEspecial, velocidad));
        //Se genera un id correspondiente al orden de creacion del pokemon
        uint id = pokemons.length - 1;
        //se asocia el id del pokemon con el usuario
        pokemonToOwner[id]=msg.sender;
        //Aumentamos la cuenta de pokemons que posee el entrenador
        ownerPokemonCount[msg.sender]++;
        //Asociacion de la dirección del usuario con el nombre de entrenador que ha escogido
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

    //funcion para procesar el elemento y devolver el poquemon correspondiente
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
    //Funcion inicial que pide el nickname de entrenador al usuario, que posteriormente es lo que ramdomizara el poder del inicial.(TrainerName)
    //Tambien se pide el elemento que es lo que definira que inicial escoge.(_elemento)
    function createPokemonInitial(string memory _elemento, string calldata _trainerName) public {
        //Cada entrenador solo puede tener un unico inicial
        require(ownerPokemonCount[msg.sender] == 0);
        //se optiene el valor aleatorio de poder
        uint randPoder = _randomPoder(_trainerName);
        //se procesa el elemento
        string memory name = processElement(_elemento);
        //se genera el pokemon
        _createPokemon(name, _elemento, randPoder, _trainerName); 
    }
    
    //Funcion para crear pokemons salvajes(_trainerName se usa para generar valores aleatorios con el nombre del entrenador)
    function createEnemyPokemon() public {
        // Definimos los nombres de las especies y sus elementos
        string[3] memory species = ["Ignis","Aqualis","Terranox"];
        string[3] memory element = ["Fuego","Agua","Tierra"];

        //Poder aleatorio (Hay que crear valores aleatorios)
        uint poderEnemigo = 1;
        
        //Estadisticas pokemon
        uint ataqueEnemigo = poderEnemigo % 10;
        uint defensaEnemigo = (poderEnemigo / 10) % 10;
        uint velocidadEnemigo = (poderEnemigo / 100) % 10;
        uint ataqueEspecialEnemigo = (poderEnemigo/100) % 10;
        uint defensaEspecialEnemigo = (poderEnemigo/1000) % 10;
        uint hpEnemigo = 50 + defensaEnemigo * 2;
        
        // Elegimos una especie y su elemento de forma pseudoaleatoria
        uint specieIndex = poderEnemigo % species.length;

        //Se aumenta el array de Pokemon
        pokemons.push(Pokemon(species[specieIndex], element[specieIndex], hpEnemigo, ataqueEnemigo, defensaEnemigo, ataqueEspecialEnemigo, 
        defensaEspecialEnemigo, velocidadEnemigo));

        //Se genera un id correspondiente al orden de creacion del pokemon
        uint id = pokemons.length - 1;

        //para generar eventos a nivel de web3
        emit NewPokemon(id, species[specieIndex], poderEnemigo);
        
    }
    //Deprecated
    /*function _removePokemon(uint _id) private {
        // Verificar que el ID del Pokémon sea válido
        require(_id >= 0 && _id < pokemons.length, "ID de Pokemon invalido.");
        
        if (_id != pokemons.length - 1) {
            // Reemplazar el Pokémon a eliminar con el último del array
            pokemons[_id] = pokemons[pokemons.length - 1];

            // Actualizar el mapeo de pokemonToOwner para el ID que fue movido
            pokemonToOwner[_id] = pokemonToOwner[pokemons.length - 1];//ID del Pokémon ahora apunte al mismo propietario que el último Pokémon del array
            pokemonToOwner[pokemons.length - 1] = address(0); // Limpieza del último índice
        }

        // Eliminar el último Pokémon
        pokemons.pop();
    }*/
}