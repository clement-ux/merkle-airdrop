// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.20;

import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {BitMaps} from "openzeppelin-contracts/utils/structs/BitMaps.sol";
import {MerkleProofLib} from "solmate/utils/MerkleProofLib.sol";

contract AirdropClaimSolmate {
    ERC20 public immutable token;

    bytes32 public merkleRoot;
    BitMaps.BitMap private _airdropList;

    constructor(bytes32 _merkleRoot, address _token) {
        merkleRoot = _merkleRoot;
        token = ERC20(_token);
    }

    function claimAirDrop(bytes32[] calldata proof, uint256 index, uint256 amount) external {
        // check if already claimed
        require(!BitMaps.get(_airdropList, index), "Already claimed");

        // verify proof
        _verifyProof(proof, index, amount, msg.sender);

        // set airdrop as claimed
        BitMaps.setTo(_airdropList, index, true);

        // transfer tokens
        token.transfer(msg.sender, amount);
    }

    function _verifyProof(bytes32[] calldata proof, uint256 index, uint256 amount, address addr) private view {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(addr, index, amount))));
        require(MerkleProofLib.verify(proof, merkleRoot, leaf), "Invalid proof");
    }

    function setMerkleRoot(bytes32 _merkleRoot) external {
        merkleRoot = _merkleRoot;
    }
}
