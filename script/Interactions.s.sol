// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {MoodNFT} from "../src/MoodNFT.sol";

contract MintBasicNFT is Script {
    string public constant HP_URI = "ipfs://QmSubs9vdCTB4U8hA3ziNr2pJnwdsxkfLjppkLuqzwV6WK";

    uint256 deployerKey;

    function run() external {
        address mostRecentlyDeployedBasicNFT = DevOpsTools
            .get_most_recent_deployment("BasicNFT", block.chainid);
        mintNFTOnContract(mostRecentlyDeployedBasicNFT);
    }

    function mintNFTOnContract(address basicNFTAddress) public {
        vm.startBroadcast();
        BasicNFT(basicNFTAddress).mintNFT(HP_URI);
        vm.stopBroadcast();
    }
}

contract MintMoodNFT is Script {
    function run() external {
        address mostRecentlyDeployedBasicNFT = DevOpsTools
            .get_most_recent_deployment("MoodNFT", block.chainid);
        mintNFTOnContract(mostRecentlyDeployedBasicNFT);
    }

    function mintNFTOnContract(address moodNFTAddress) public {
        vm.startBroadcast();
        MoodNFT(moodNFTAddress).mintNFT();
        vm.stopBroadcast();
    }
}

contract FlipMoodNFT is Script {
    uint256 public constant TOKEN_ID_TO_FLIP = 0;

    function run() external {
        address mostRecentlyDeployedBasicNFT = DevOpsTools
            .get_most_recent_deployment("MoodNFT", block.chainid);
        flipMoodNFT(mostRecentlyDeployedBasicNFT);
    }

    function flipMoodNFT(address moodNFTAddress) public {
        vm.startBroadcast();
        MoodNFT(moodNFTAddress).flipMood(TOKEN_ID_TO_FLIP);
        vm.stopBroadcast();
    }
}
