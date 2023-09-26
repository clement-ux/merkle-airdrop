import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";
import { ethers } from "ethers";
import generateRandomData from './randomValuesGenerator.js';

// (0)
const VOYAGERS = 20_000;

// (1)
const values = generateRandomData(VOYAGERS);

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
fs.writeFileSync("merkletree-script/tree.json", JSON.stringify(tree.dump()));