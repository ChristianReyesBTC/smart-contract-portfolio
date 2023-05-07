// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC721o is ERC721, Ownable {
    constructor() ERC721("myERC721o", "721") {}

    struct Meta {
      string name;
      string description;
      string image;
      string external_url;
      address creator;
      string collection;
      // mapping(string => string) attributes; so that somehow. 
    }
    //No actual standards exist, just best pracitces. 
    //Name: A string that represents the name of the token.
    //Description: A string that provides a description of the token.
    //Image: A URL that points to an image that represents the token.
    //External URL: A URL that points to an external resource that provides more information about the token.
    //Creator: The address of the account that created the token.
    //Collection: The name or ID of the collection that the token belongs to.
    //Properties: A JSON object that provides additional information about the token, such as its rarity, attributes, or other custom properties.

    mapping(uint => Meta) public tokenMetadata;

    function _baseURI() internal pure override returns (string memory) {
        return "myuri";
    }

    function safeMint(address to, uint256 tokenId, string memory _name, string memory description, string memory _image, string memory _link, string memory _collection) public onlyOwner {
        _safeMint(to, tokenId);
        tokenMetadata[tokenId] = Meta({
        name: _name,
        description: _description,
        image: _image,
        link: _link,
        creator: msg.sender,
        collection: _collection
    });
}


//https://docs.opensea.io/docs/metadata-standards was thinking of making them openseas standard. 