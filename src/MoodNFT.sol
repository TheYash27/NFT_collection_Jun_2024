// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721, Ownable {
    error ERC721Metadata__URI_QueryFor_NonExistentToken();
    error MoodNFT__CannotFlipMoodIfNotOwner();

    enum NFTState {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_sadSVGURI;
    string private s_happySVGURI;

    mapping(uint256 => NFTState) private s_tokenIDToState;

    event CreatedNFT(uint256 indexed tokenID);

    constructor(string memory sadSVGURI, string memory happySVGURI) ERC721("Mood NFT", "MN") Ownable(msg.sender) {
        s_tokenCounter = 0;
        s_sadSVGURI = sadSVGURI;
        s_happySVGURI = happySVGURI;
    }

    function mintNFT() public {
        // how would you require payment for this NFT?
        uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
        emit CreatedNFT(tokenCounter);
    }

    function flipMood(uint256 tokenID) public {
        if (getApproved(tokenID) != msg.sender && ownerOf(tokenID) != msg.sender) {
            revert MoodNFT__CannotFlipMoodIfNotOwner();
        }

        if (s_tokenIDToState[tokenID] == NFTState.HAPPY) {
            s_tokenIDToState[tokenID] = NFTState.SAD;
        } else {
            s_tokenIDToState[tokenID] = NFTState.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenID) public view virtual override returns (string memory) {
        if (ownerOf(tokenID) == address(0)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }
        string memory imageURI = s_happySVGURI;

        if (s_tokenIDToState[tokenID] == NFTState.SAD) {
            imageURI = s_sadSVGURI;
        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"',
                            'Mood', // You can add whatever name here
                            '", "description":"1 dynamic NFT that reflects mood of owner which is 100% on-chain!", ',
                            '"attributes": [{"trait_type": "Mood", "value": 0.5}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySVGURI;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSVGURI;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
