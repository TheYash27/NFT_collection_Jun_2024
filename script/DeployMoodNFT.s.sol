// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/console.sol";

contract DeployMoodNFT is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (MoodNFT) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        string memory sadSVG = vm.readFile("./images/dynamicNft/sad.svg");
        string memory happySVG = vm.readFile("./images/dynamicNft/happy.svg");

        vm.startBroadcast(deployerKey);
        MoodNFT moodNFT = new MoodNFT(SVGToImageURI(sadSVG), SVGToImageURI(happySVG));
        vm.stopBroadcast();
        return moodNFT;
    }

    // You could also just upload the raw SVG and have solildity convert it!
    function SVGToImageURI(string memory SVG) public pure returns (string memory) {
        // example:
        // '<svg width="500" height="500" viewBox="0 0 285 350" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill="black" d="M150,0,L75,200,L225,200,Z"></path></svg>'
        // would return ""
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory SVGBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(SVG))) // Removing unnecessary type castings, this line can be resumed as follows : 'abi.encodePacked(svg)'
        );
        return string(abi.encodePacked(baseURI, SVGBase64Encoded));
    }
}
