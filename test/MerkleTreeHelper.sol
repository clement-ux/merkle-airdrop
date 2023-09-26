// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.20;

import "forge-std/Test.sol";

contract MerkleTreeHelper is Test {
    function getProof(address user) public returns (uint256, uint256, bytes32[] memory) {
        //returns(bytes32) {
        string[] memory inputs = new string[](3);
        inputs[0] = "node";
        inputs[1] = "merkletree-script/merkleProof.js";
        inputs[2] = vm.toString(user);

        return abi.decode(vm.ffi(inputs), (uint256, uint256, bytes32[]));
    }

    function getRoot() public returns (bytes32) {
        string[] memory inputs = new string[](2);
        inputs[0] = "node";
        inputs[1] = "merkletree-script/createMerkleTree.js";

        return abi.decode(vm.ffi(inputs), (bytes32));
    }
}
