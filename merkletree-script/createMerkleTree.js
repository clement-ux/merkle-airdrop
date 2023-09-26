import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";
import { ethers } from "ethers";


// (1)
const values = [
  ["0x328809Bc894f92807417D2dAD6b7C998c1aFdac6", "0", "10000000000000000000"], // makeAddr("alice")
  ["0x1D96F2f6BeF1202E4Ce1Ff6Dad0c2CB002861d3e", "1", "20000000000000000000"], // makeAddr("bob")
  ["0x0000000000000000000000000000000000000003", "2", "30000000000000000000"],
  ["0x0000000000000000000000000000000000000004", "3", "40000000000000000000"],
  ["0x0000000000000000000000000000000000000005", "4", "50000000000000000000"],
  ["0x0000000000000000000000000000000000000006", "5", "60000000000000000000"],
  ["0x0000000000000000000000000000000000000007", "6", "70000000000000000000"],
  ["0x0000000000000000000000000000000000000008", "7", "80000000000000000000"],
];

// (2)
const tree = StandardMerkleTree.of(values, ["address", "uint256", "uint256"]);

// (3)
const abi = new ethers.AbiCoder();
const root = abi.encode(
  ["bytes32"],
  [tree.root]
);
console.log(root);

// (4)
fs.writeFileSync("tree.json", JSON.stringify(tree.dump()));