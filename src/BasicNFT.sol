// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    error BasicNFT__TokenURINotFound();

    mapping(uint256 tokenID => string tokenURI) private s_tokenIDToURI;
    uint256 private s_tokenCounter;

    constructor() ERC721 ("Harry Potter", "HP") {
        s_tokenCounter = 0;
    }

    function mintNFT(string memory tokenURI) public {
        s_tokenIDToURI[s_tokenCounter] = tokenURI;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    function tokenURI(uint256 tokenID) public view override returns (string memory) {
        if (ownerOf(tokenID) == address(0)) {
            revert BasicNFT__TokenURINotFound();
        }
        return s_tokenIDToURI[tokenID];
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
