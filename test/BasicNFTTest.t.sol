// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {MintBasicNFT} from "../script/Interactions.s.sol";

contract BasicNFTTest is StdCheats, Test {
    string constant NFT_NAME = "Harry Potter";
    string constant NFT_SYMBOL = "HP";
    BasicNFT public basicNFT;
    DeployBasicNFT public deployer;
    address public deployerAddress;

    string public constant HP_URI =
        "ipfs://QmSubs9vdCTB4U8hA3ziNr2pJnwdsxkfLjppkLuqzwV6WK";
    address public constant USER = address(1);

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function testInitializedCorrectly() public view {
        assert(
            keccak256(abi.encodePacked(basicNFT.name())) ==
                keccak256(abi.encodePacked((NFT_NAME)))
        );
        assert(
            keccak256(abi.encodePacked(basicNFT.symbol())) ==
                keccak256(abi.encodePacked((NFT_SYMBOL)))
        );
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNFT.mintNFT(HP_URI);

        assert(basicNFT.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        basicNFT.mintNFT(HP_URI);

        assert(
            keccak256(abi.encodePacked(basicNFT.tokenURI(0))) ==
                keccak256(abi.encodePacked(HP_URI))
        );
    }

    function testMintWithScript() public {
        uint256 startingTokenCount = basicNFT.getTokenCounter();
        MintBasicNFT mintBasicNFT = new MintBasicNFT();
        mintBasicNFT.mintNFTOnContract(address(basicNFT));
        assert(basicNFT.getTokenCounter() == startingTokenCount + 1);
    }

    // can you get the coverage up?
}
