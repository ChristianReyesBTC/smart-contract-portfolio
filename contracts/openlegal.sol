// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//cant find the contracts-"upgradable" for whater reason its not in the openzepplin dependencies. 
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/draft-ERC721VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";


//These line declare the OpenLegal contract and the contracts it inherits from with the "is" these are probably the features (functions) that I checked on open zepplin. (should probably audit them to understad how they work.)
contract openlegal is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, ERC721BurnableUpgradeable, OwnableUpgradeable, EIP712Upgradeable, ERC721VotesUpgradeable {
    // This line allows the contract to use the methods of the CountersUpgradeable library on CountersUpgradeable.Counter instances.
    using CountersUpgradeable for CountersUpgradeable.Counter;

    //This line declares a private counter variable that's used to assign unique IDs to tokens.
    CountersUpgradeable.Counter private _tokenIdCounter;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
      //this just makes sure that you will not 
        _disableInitializers();
    }
    //  constructor cannot be used for initialization. OpenZeppelin's upgradeable contracts use an initializer function instead of a constructor for setting up the contract's initial state. This function can be called manually after the contract has been hooked up to the proxy. A proxy contract, which is the contract that users will interact with directly. The implementation contract, which contains the logic of your contract.

    // struct for ContractDetails
    struct ContractDetails {
        string contractText;
        address[] parties;
        mapping(address => bytes) publicSig; // Mapping of party address to signature
        // bytes[]   publicSig;
        //would publicSig be an array as well since there can be multiple signatures?
    }
    // mapping from tokenID (nft) to ContractDetails
    mapping (uint256 => ContractDetails) private _contractDetails;

    // mapping for signature from private key. 
    //mapping (uint256 => mapping (address => bytes)) private _privatesig;


    // True initializer of contracts. This should be the A proxy contract, which is the contract that users will interact with directly. The implementation contract, which contains the logic of your contract. This function serves the role of the constructor in an upgradeable contract. It's manually called after the contract is deployed and linked to a proxy. It sets up the initial state of the contract, just like a constructor.
    //You're correct in your observation. The mechanism to ensure the initialize function isn't called more than once is not explicitly shown in your code. However, OpenZeppelin's upgradeable contracts, which you're using here, handle this internally. The initializer modifier in the function declaration function initialize() initializer public {...} takes care of this.
    function initialize() initializer public {
        __ERC721_init("OpenLegal", "LEGAL");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __ERC721Burnable_init();
        __Ownable_init();
        __EIP712_init("OpenLegal", "1");
        __ERC721Votes_init();
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipsf://OpenLegalBaseuir";
    }
    //this is the URI that the function returns. URL or IPFS link where metadata about the tokens is stored. The specific token's ID is usually appended to this base URI to construct the full URI for each token's metadata. So if your base URI is "ipsf://OpenLegalBaseuir" and you're looking for the metadata for token ID 1, you might look at "ipsf://OpenLegalBaseuir/1".

  //deleted onlyowner modifier so that anyone can call this functions and create a contract. 
    // function safeMint(address to, string memory uri) public {
    //     uint256 tokenId = _tokenIdCounter.current();
    //     _tokenIdCounter.increment();
    //     _safeMint(to, tokenId);
    //     _setTokenURI(tokenId, uri);
    // }

    // Updated the safeMint function to include contractdetails & publicSig
    // maybe we hardcode an address that holds all the contracts in a single address? 
    // The user prepares the data that they want to sign. This could be a contract or any other piece of information.
      // Using a web3 library in their client application (like a JavaScript app), they call web3.eth.sign(), providing their account address   and the data to be signed.
      // The user's Ethereum client (like Metamask) will pop up a window asking the user to confirm that they want to sign the data and store that in the publicSig perameter.
      // Once the user confirms, the web3.eth.sign() function will return a promise that resolves to the signature, which is a string of 'bytes'. This signature can then be sent to the smart contract in a transaction some how.
    function safeMint(address to, string memory contractText, address[] memory parties, bytes publicSig) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    //this creates the nft with a unique ID . 

    // This Stores the contract details into that newlyminted ntf.
        ContractDetails storage newContract = _contractDetails[tokenId];
          newContract.contractText = contractText;
          newContract.parties = parties;
          newContract.publicSig = publicSig;
    }

    //function that allows for the secont party to sign the contract with your private key. 
    function signContract(uint256 tokenId, bytes memory signature) public {
        ContractDetails storage details = _contractDetails[tokenId]; // Use storage instead of memory to modify state

        bool isParty = false;
        for (uint i = 0; i < details.parties.length; i++) {
            if (details.parties[i] == msg.sender) {
                isParty = true;
                break;
            }
        }

        require(isParty, "Only a party to the contract can sign it.");
        require(details.publicSig[msg.sender].length == 0, "Contract already signed.");

        // Store the signature
        details.publicSig[msg.sender] = signature;
    }


    // function to retrieve the contract details for a given token ID
    function getContractDetails(uint256 tokenId) public view returns (ContractDetails memory) {
        return _contractDetails[tokenId];
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _afterTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721Upgradeable, ERC721VotesUpgradeable)
    {
        super._afterTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
