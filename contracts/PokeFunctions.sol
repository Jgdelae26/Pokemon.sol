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
  
    //Función para ver los poquemons que tiene una direccion en concreto. No es la forma que seria mas practica pero si la mas eficiente, ya que
    // trabajamos con un array nuevo de tipo memory y no modificamos ningun array de los que tenemos en storage directamente entonces este array en memory se
    //creara cada vez que se llame la funcion y se recorrera el array en storage buscando los pokemon de la direeccion. Poco eficiente pero barat.
    //Mejor explicado en https://cryptozombies.io/es/lesson/3/chapter/12
    function getPokemonByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerPokemonCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < pokemons.length; i++) {
            if (pokemonToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    //Dispara el timepo de recuperacion de un pokemon
    function _disparadorDeRecu(Pokemon storage _pokemon) internal {
        _pokemon.readyTime = uint32(block.timestamp + tiempoRecu);
    }

    //Comprueba que el pokemon este recuperado
    function _isReady(Pokemon storage _pokemon) internal view returns (bool) {
        return (_pokemon.readyTime <= block.timestamp);
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

    //Aumento de alguna de las stats dentro del struc estas estan indexadas y se puede acceder a ellas mediante
    function _modificacionEstats(Pokemon storage _myPokemon, uint8 indexStat, uint8 _cantidadSubida) internal {
        if (indexStat == 1) {
            _myPokemon.ataque = _myPokemon.ataque + _cantidadSubida;
        } else if (indexStat == 2) {
            _myPokemon.defensa = _myPokemon.defensa + _cantidadSubida;
        } else if (indexStat == 3) {
            _myPokemon.ataqueEspecial = _myPokemon.ataqueEspecial + _cantidadSubida;
        } else if (indexStat == 4) {
          _myPokemon.defensaEspecial = _myPokemon.defensaEspecial + _cantidadSubida;
        } else {
          _myPokemon.defensaEspecial = _myPokemon.defensaEspecial + _cantidadSubida;
        }
    }
}
