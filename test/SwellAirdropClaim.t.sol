// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "forge-std/Test.sol";

import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {SwellAirdropClaim} from "src/SwellAirdropClaim.sol";

import {MerkleTreeHelper} from "test/MerkleTreeHelper.sol";

contract SwellAirdropClaimTest is MerkleTreeHelper {
    MockERC20 public swell = new MockERC20("Swell DAO token", "SWELL", 18);
    SwellAirdropClaim public claim = new SwellAirdropClaim(0x0, address(swell));

    address public immutable alice = makeAddr("alice");
    address public immutable bob = makeAddr("bob");

    uint256 public constant TOTAL_AIRDROP = 1_000_000e18;

    modifier setMerkelRoot() {
        claim.setMerkleRoot(getRoot());
        _;
    }

    modifier sendTokenToMerkle(uint256 _amount) {
        swell.mint(address(claim), _amount);
        _;
    }

    function test_ClaimAirDrop_Alice() public setMerkelRoot sendTokenToMerkle(TOTAL_AIRDROP) {
        // Check before
        assertEq(swell.balanceOf(alice), 0);

        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);

        // Claim Airdrop
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);

        // Check after
        assertEq(swell.balanceOf(alice), amount);
    }

    function test_RevertWhen_NoTokenOnContract() public setMerkelRoot {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);

        vm.expectRevert();
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);
    }

    function test_RevertWhen_AlreadyClaimed() public setMerkelRoot sendTokenToMerkle(TOTAL_AIRDROP) {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);

        // Claim Airdrop
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);

        // Claim Again
        vm.expectRevert("Already claimed");
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);
    }

    function test_RevertWhen_ProofIsInvalid() public setMerkelRoot {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);
        // Modify proof
        proof[0] = bytes32("123");

        // Claim Airdrop
        vm.expectRevert("Invalid proof");
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);
    }

    function test_RevertWhen_AmountIsInvalid() public setMerkelRoot {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);
        // Modify amount
        amount -= 1;

        // Claim Airdrop
        vm.expectRevert("Invalid proof");
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);

        // Modify amount
        amount += 2;

        // Claim Airdrop
        vm.expectRevert("Invalid proof");
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);
    }

    function test_RevertWhen_IndexIsInvalid() public setMerkelRoot {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);
        // Modify index
        index += 1;

        // Claim Airdrop
        vm.expectRevert("Invalid proof");
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);
    }

    function test_RevertWhen_WrongCaller() public setMerkelRoot sendTokenToMerkle(TOTAL_AIRDROP) {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);

        // Claim Airdrop
        vm.expectRevert("Invalid proof");
        vm.prank(bob);
        claim.claimAirDrop(proof, index, amount);
    }
}
