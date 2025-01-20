// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
//Imports
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract PokeOwnership is ERC1155 {
    constructor() ERC1155("https://ipfs.io/ipfs/{id}") { }

    function pokemint(address _trainer, uint256[] memory _ids, uint256[] memory _amounts) internal {
        _mintBatch( _trainer,  _ids,  _amounts, "");
    }
    /*
    Funciones de la interfaz del erc 1155:
    
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external{

    }

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