// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {DeployMoodNFT} from "../script/DeployMoodNFT.s.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {MintBasicNFT} from "../script/Interactions.s.sol";

contract MoodNFTTest is StdCheats, Test {
    string constant NFT_NAME = "Mood NFT";
    string constant NFT_SYMBOL = "MN";
    MoodNFT public moodNFT;
    DeployMoodNFT public deployer;
    address public deployerAddress;

    string public constant HAPPY_MOOD_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjIwMCIgaGVpZ2h0PSIyMDAiPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgcj0iNzUiIGZpbGw9InllbGxvdyIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CgogIDxjaXJjbGUgY3g9IjcwIiBjeT0iODAiIHI9IjE1IiBmaWxsPSJibGFjayIvPgogIDxjaXJjbGUgY3g9IjEzMCIgY3k9IjgwIiByPSIxNSIgZmlsbD0iYmxhY2siLz4KCiAgPHBhdGggZD0iTTY1LDEwMCBDOTAsMTMwLCAxMTAsMTMwLCAxMzUsMTAwIiAKICAgICAgICBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjMiIGZpbGw9InRyYW5zcGFyZW50Ii8+Cjwvc3ZnPgo=";

    string public constant SAD_MOOD_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjIwMCIgaGVpZ2h0PSIyMDAiPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgcj0iNzUiIGZpbGw9InllbGxvdyIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CgogIDxjaXJjbGUgY3g9IjcwIiBjeT0iMTMwIiByPSIxNSIgZmlsbD0iYmxhY2siLz4KICA8Y2lyY2xlIGN4PSIxMzAiIGN5PSIxMzAiIHI9IjE1IiBmaWxsPSJibGFjayIvPgoKICA8cGF0aCBkPSJNNjUsMTAwIEM5MCw3MCwgMTEwLDcwLCAxMzUsMTAwIiAKICAgICAgICBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjMiIGZpbGw9InRyYW5zcGFyZW50Ii8+Cjwvc3ZnPgoK";

    address public constant USER = address(1);

    function setUp() public {
        deployer = new DeployMoodNFT();
        moodNFT = deployer.run();
    }

    function testInitializedCorrectly() public view {
        assert(
            keccak256(abi.encodePacked(moodNFT.name())) ==
                keccak256(abi.encodePacked((NFT_NAME)))
        );
        assert(
            keccak256(abi.encodePacked(moodNFT.symbol())) ==
                keccak256(abi.encodePacked((NFT_SYMBOL)))
        );
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        moodNFT.mintNFT();

        assert(moodNFT.balanceOf(USER) == 1);
    }

    function testTokenURIDefaultIsCorrectlySet() public {
        vm.prank(USER);
        moodNFT.mintNFT();

        assert(
            keccak256(abi.encodePacked(moodNFT.tokenURI(0))) ==
                keccak256(abi.encodePacked(HAPPY_MOOD_URI))
        );
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNFT.mintNFT();

        vm.prank(USER);
        moodNFT.flipMood(0);

        assert(
            keccak256(abi.encodePacked(moodNFT.tokenURI(0))) ==
                keccak256(abi.encodePacked(SAD_MOOD_URI))
        );
    }

    function testEventRecordsCorrectTokenIDOnMinting() public {
        uint256 currentAvailableTokenID = moodNft.getTokenCounter();

        vm.prank(USER);
        vm.recordLogs();
        moodNFT.mintNFT();
        Vm.Log[] memory entries = vm.getRecordedLogs();

        bytes32 tokenID_proto = entries[1].topics[1];
        uint256 tokenID = uint256(tokenID_proto);

        assertEq(tokenID, currentAvailableTokenID);
    }
}

