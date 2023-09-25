// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "forge-std/Test.sol";

import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {SwellAirdropClaim} from "src/SwellAirdropClaim.sol";

contract SwellAirdropClaimTest is Test {
    MockERC20 public swell = new MockERC20("Swell DAO token", "SWELL", 18);
    SwellAirdropClaim public claim = new SwellAirdropClaim(0x0, address(swell));

    address public immutable alice = makeAddr("alice");
    address public immutable bob = makeAddr("bob");

    bytes32 public constant ROOT_ALICE_10__BOB_20 = 0x3b8c4c97dc6042346711b6b2324c4891a253bc59f4b7590c0f96e98a36213b33;

    modifier setMerkelRoot(bytes32 _root) {
        claim.setMerkleRoot(_root);
        _;
    }

    modifier sendTokenToMerkle(uint256 _amount) {
        swell.mint(address(claim), _amount);
        _;
    }

    function test_ClaimAirDrop_Alice() public setMerkelRoot(ROOT_ALICE_10__BOB_20) sendTokenToMerkle(30e18) {
        assertEq(swell.balanceOf(alice), 0);
        vm.prank(alice);
        claim.claimAirDrop({
            proof: convertProof(
                [
                    0x504f4f242789630453773b19a063300999542af3e8b5cc8a4557c478b63c4125,
                    0xc063f637deca64a99410d907f92c14069d568445d6cef2b703927518ab7ead3f,
                    0xb0621b5538d613a415043d5ac5d44bdef3ea31bc8c9a23051d24cfcebd2468d5
                ]
                ),
            index: 0,
            amount: 10e18
        });

        assertEq(swell.balanceOf(alice), 10e18);
    }

    function convertProof(uint256[3] memory proofs) public pure returns (bytes32[] memory proofs_) {
        proofs_ = new bytes32[](proofs.length);
        for (uint256 i; i < proofs.length; i++) {
            proofs_[i] = bytes32(proofs[i]);
        }
    }

    function convertProof(uint256[4] memory proofs) public pure returns (bytes32[] memory proofs_) {
        proofs_ = new bytes32[](proofs.length);
        for (uint256 i; i < proofs.length; i++) {
            proofs_[i] = bytes32(proofs[i]);
        }
    }

    function convertProof(uint256[5] memory proofs) public pure returns (bytes32[] memory proofs_) {
        proofs_ = new bytes32[](proofs.length);
        for (uint256 i; i < proofs.length; i++) {
            proofs_[i] = bytes32(proofs[i]);
        }
    }
}
