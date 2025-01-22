// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
//Imports
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract PokeOwnership is ERC1155 {
    constructor() ERC1155("https://ipfs.io/ipfs/{id}") { }

    //Para guardar el dueño de un pokemon, vamos a usar dos mapeos: el primero guardará el rastro de la dirección 
    //que posee ese pokemon y la otra guardará el rastro de cuantos pokemon posee cada propietario.
    mapping (uint => address) public pokemonToOwner;
    mapping (address => uint) ownerPokemonCount;

    function pokemint(address _trainer, uint256[] memory _ids, uint256[] memory _amounts) internal {
        _mintBatch( _trainer,  _ids,  _amounts, "");
    }

    function _transfer(address _from, address _to) private {
        ownerPokemonCount[_to]++;
        ownerPokemonCount[_from]--;

        pokemonToOwner[_tokenId] = _to;
    }

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) public override {
        //Cuando no es moneda hay que actualizar los mapping de los pokemons
        if(_id != 1){
            _transfer(_from, _to, _data);
        }
        
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