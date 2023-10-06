// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract AirdropClaim1Inch {
    // using MerkleProof for bytes32[];

    // solhint-disable-next-line immutable-vars-naming
    address public immutable token;

    bytes32 public merkleRoot;
    mapping(address => uint256) public cumulativeClaimed;

    event MerkelRootUpdated(bytes32 oldMerkleRoot, bytes32 newMerkleRoot);
    // This event is triggered whenever a call to #claim succeeds.
    event Claimed(address indexed account, uint256 amount);

    error InvalidProof();
    error NothingToClaim();
    error MerkleRootWasUpdated();

    constructor(address token_) {
        token = token_;
    }

    function setMerkleRoot(bytes32 merkleRoot_) external {
        emit MerkelRootUpdated(merkleRoot, merkleRoot_);
        merkleRoot = merkleRoot_;
    }


    function claim(
        address account,
        uint256 cumulativeAmount,
        bytes32 expectedMerkleRoot,
        bytes32[] calldata merkleProof,
        uint256 index
    ) external {
        if (merkleRoot != expectedMerkleRoot) revert MerkleRootWasUpdated();

        // Verify the merkle proof
        
        // Slightly modified, to have the same encoding as the others.
        // Original:
        // bytes32 leaf = keccak256(abi.encodePacked(account, cumulativeAmount));
        // Modified:
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, index, cumulativeAmount))));
        if (!_verifyAsm(merkleProof, expectedMerkleRoot, leaf)) revert InvalidProof();

        // Mark it claimed
        uint256 preclaimed = cumulativeClaimed[account];
        if (preclaimed >= cumulativeAmount) revert NothingToClaim();
        cumulativeClaimed[account] = cumulativeAmount;

        // Send the token
        unchecked {
            uint256 amount = cumulativeAmount - preclaimed;
            ERC20(token).transfer(account, amount);
            emit Claimed(account, amount);
        }
    }

    // function verify(bytes32[] calldata merkleProof, bytes32 root, bytes32 leaf) public pure returns (bool) {
    //     return merkleProof.verify(root, leaf);
    // }

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
