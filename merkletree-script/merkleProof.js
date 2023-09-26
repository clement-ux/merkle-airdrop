import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";
import { ethers } from "ethers";

// (1)
const tree = StandardMerkleTree.load(JSON.parse(fs.readFileSync("merkletree-script/tree.json")));

// (2)
//console.log(process.argv[2]);
for (const [i, v] of tree.entries()) {
  if (v[0] === process.argv[2]) {
    // (3)
    const index = v[1];
    const amount = v[2];
    const proof = tree.getProof(i);

    let arr = [];
    for (let k = 0; k < proof.length; k++) {
      arr.push(proof[k]);
    }

    const abi = new ethers.AbiCoder();
    const params = abi.encode(
      ["uint256", "uint256", "bytes32[]"],
      [index, amount, arr]);

    console.log(params);
  }
}
