// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
//Imports
import "@openzeppelin/contracts@4.8.2/access/Ownable.sol";
import "./PokeOwnership.sol";

contract PokemonFactory is Ownable, PokeOwnership {

    constructor() Ownable(msg.sender) { 
    
    }

    //para generar eventos a nivel de web3
    event NewPokemon(uint pokemonId, string name, uint poder);

    uint8 poderDigits = 5;
    //Nos sirve para limitar el tamaño de la variable poder a 5 digitos
    uint32 poderModulus = uint32(10 ** poderDigits);
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
        uint numPokemonsTotales;
    }

    //Array de pokemons
    Pokemon[] public pokemons;

    //Array de Entrenadores
    Entrenador[] public entrenadores;

    //Para guardar el dueño de un pokemon, vamos a usar dos mapeos: el primero guardará el rastro de la dirección 
    //que posee ese pokemon y la otra guardará el rastro de cuantos pokemon posee cada propietario.
    mapping (uint => address) public pokemonToOwner;
    mapping (address => uint) ownerPokemonCount;

    //Mapping para guardar el nombre del entrenador
    mapping (address => string) public trainerName;


    //Funcion principal para crear pokemons arraigados a un entrenador. Internal porque nos interesa que contratos que hereden de este puedan emplearla.
    function _createPokemon(string memory _name, uint8 _idEspecie, string memory _elemento, uint16  _poder, string calldata _trainerName) internal {
        //Tratamiento de los stats en funcion de la var aleatoria poder
        uint8 ataque = uint8(_poder % 10);
        uint8 defensa = uint8((_poder/10) % 10);
        uint8 ataqueEspecial = uint8((_poder/100) % 10);
        uint8 defensaEspecial = uint8((_poder/1000) % 10);
        uint8 velocidad= uint8((_poder/10**4) % 10);
        //Se aumenta el array de Pokemon
        pokemons.push(Pokemon(_name, _elemento, 0, 0, ataque, defensa, ataqueEspecial, defensaEspecial, velocidad));
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
        /*Incorporacion del ERC1155:
        Crea la intancia del token dependiendo del pokemon, es decir, cada pokemon es un token 
        pero como estos se pueden repetir hay multiplicidad con diferentes caracteristicas entre ellos.
        Además se añaden 100 pokecoins a la direccion.
        */
        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = _idEspecie;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 100; 
        amounts[1] = 1;
        pokemint(msg.sender, ids, amounts);
    }

    //keccak256 es una version de SHA3 que es una funcion Hash que retorna 256-bits en un formato de numero hexadecimal 
    //que empleamos como pseudo aleatorio, DEBERIAMOS ENCONTRAR UNA MANERA MEJOR 
    function _randomPoder(string calldata _str) private view returns(uint16) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return uint16(rand % poderModulus);
    }
    //funcion para procesar el elemento y devolver el poquemon correspondiente el hecho de que sea pure ayuda a optimizar 
    //el consumo de gas e implica que la funcion no reliaza consultas o modificaciones en la blockchain
    function processElement(string memory _element) private pure returns (string memory, uint8 ) {
        bytes32 elementHash = keccak256(abi.encodePacked(_element));

        if (elementHash == keccak256(abi.encodePacked("Agua"))) {
            return ("Aqualis", 2);
        } else if (elementHash == keccak256(abi.encodePacked("Fuego"))) {
            return ("Ignis", 3);
        } else if (elementHash == keccak256(abi.encodePacked("Tierra"))) {
            return ("Terranox", 4);
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
        uint16 randPoder = _randomPoder(_trainerName);
        //se procesa el elemento
        (string memory _name, uint8 _idEspecie) = processElement(_elemento);
        //se genera el pokemon
        _createPokemon(_name, _idEspecie, _elemento, randPoder, _trainerName); 
    }
    
}