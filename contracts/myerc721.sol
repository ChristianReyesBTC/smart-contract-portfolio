// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//off chain metadata
contract MyERC721 is ERC721, ERC721URIStorage, Ownable {
    constructor() ERC721("myERC721", "721") {}

    function _baseURI() internal pure override returns (string memory) {
        // Return the base URI for your token metadata. off chain. 
        return "myuri";
    }
     
    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyOwner
    {
        // Call the _safeMint() function of ERC721 to mint a new token with the specified ID and assign it to the specified address
        _safeMint(to, tokenId);
        // Call the _setTokenURI() function of ERC721URIStorage to associate the specified metadata URI with the new token
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.


//
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        // Call the _burn() function of both ERC721 and ERC721URIStorage to delete the metadata associated with the token. 
        super._burn(tokenId);
    }
    // Define a public function tokenURI() that overrides the tokenURI() function provided by ERC721URIStorage
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}


