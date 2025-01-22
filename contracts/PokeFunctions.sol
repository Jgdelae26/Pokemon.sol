// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./PokeCouch.sol";

contract PokeFunctions is PokeCouch {

    uint levelUpFee = 0.001 ether;

    function withdraw() external onlyOwner {
      address payable ownerPayable = payable(owner()); 
      ownerPayable.transfer(address(this).balance);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
      levelUpFee = _fee;
    }

    function levelUp(uint _pokemonId) external payable {
      require(msg.value == levelUpFee);
      pokemons[_pokemonId].level++;
    }
  

    //Comprueba que el nivel del pokemon es superior o igual al que se le indica
    modifier aboveLevel(uint256 _level, uint256 _pokemonId) {
        require(pokemons[_pokemonId].level >= _level);
        _;
    }

    //Cambio de nombre del pokemon
    function changeName(uint256 _pokemonId, string calldata _newName)
        external
        aboveLevel(5, _pokemonId)
    {
        //hace modifier para esta sentencia 
        require(msg.sender == pokemonToOwner[_pokemonId]);
        pokemons[_pokemonId].name = _newName;
    }


}
