import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";

// (1)
const tree = StandardMerkleTree.load(JSON.parse(fs.readFileSync("tree.json")));

// (2)
for (const [i, v] of tree.entries()) {
  if (v[0] === "0x328809Bc894f92807417D2dAD6b7C998c1aFdac6") {
    // (3)
    const proof = tree.getProof(i);
    console.log("Value:", v);
    console.log("Proof:", proof);
  }
}