// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
//Imports
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./Trainer.sol";

contract PokeOwnership is ERC1155, Trainer {
    constructor() ERC1155("https://ipfs.io/ipfs/{id}") { }

        struct Pokemon {
        string name;
        string elemento;
        uint readyTime;
        uint8 level;
        uint32 hpPokemon;
        //uint8 para obtimizar los costes de gas tenemos 256 maximo
        uint8 ataque;
        uint8 defensa;
        uint8 ataqueEspecial;
        uint8 defensaEspecial;
        uint8 velocidad;
    }

    //Array de pokemons
    Pokemon[] public pokemons;

    //Para guardar el dueño de un pokemon, vamos a usar dos mapeos: el primero guardará el rastro de la dirección 
    //que posee ese pokemon y la otra guardará el rastro de cuantos pokemon posee cada propietario.
    mapping (uint => address) public pokemonToOwner;
    mapping (address => uint) ownerPokemonCount;

    function pokemint(address _trainer, uint256[] memory _ids, uint256[] memory _amounts) internal {
        _mintBatch( _trainer,  _ids,  _amounts, "");
    }

    function _transfer(address _from, address _to, uint _tokenId) private {
        ownerPokemonCount[_to]++;
        ownerPokemonCount[_from]--;
        pokemonToOwner[_tokenId] = _to;
        // Recuperar el índice del entrenador
        uint indexF = addressToEntrenadorIndex[msg.sender];
        // Le suma uno al recuento de pokemons totales
        entrenadores[indexF].numPokemons--;
        uint indexT = addressToEntrenadorIndex[_to];
        // Le suma uno al recuento de pokemons totales
        entrenadores[indexT].numPokemons++; 
    }

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) public override {
        if(_id != 1){
          uint pokeid  = abi.decode(_data, (uint256));
            for (uint256 i = 0; i < pokemons.length; i++) {
                //ademas se comprueba que el id que se pasa el dueño sea el que toca
                if (pokemonToOwner[i] == _from && i == pokeid) {
                    _transfer(_from, _to, pokeid);
                }
            }
        }
        super.safeTransferFrom(_from, _to, _id, _value, _data);
        
    }
    /*
    Funciones de la interfaz del erc 1155:

    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external{

    }

    function balanceOf(address _owner, uint256 _id) external view returns (uint256){

    }

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory){

    }
    
    function setApprovalForAll(address _operator, bool _approved) external{

    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool){

    }
    */
}