// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {BitMaps} from "openzeppelin-contracts/utils/structs/BitMaps.sol";
import {MerkleProofLib} from "solady/src/utils/MerkleProofLib.sol";

contract AirdropClaim1Inch {
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
        require(_verifyAsm(proof, merkleRoot, leaf), "Invalid proof");
    }

    function setMerkleRoot(bytes32 _merkleRoot) external {
        merkleRoot = _merkleRoot;
    }

    function _verifyAsm(bytes32[] calldata proof, bytes32 root, bytes32 leaf) private pure returns (bool valid) {
        /// @solidity memory-safe-assembly
        assembly {
            // solhint-disable-line no-inline-assembly
            let ptr := proof.offset

            for { let end := add(ptr, mul(0x20, proof.length)) } lt(ptr, end) { ptr := add(ptr, 0x20) } {
                let node := calldataload(ptr)

                switch lt(leaf, node)
                case 1 {
                    mstore(0x00, leaf)
                    mstore(0x20, node)
                }
                default {
                    mstore(0x00, node)
                    mstore(0x20, leaf)
                }

                leaf := keccak256(0x00, 0x40)
            }

            valid := eq(root, leaf)
        }
    }
}
