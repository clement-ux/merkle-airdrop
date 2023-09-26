// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "forge-std/Test.sol";

import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {SwellAirdropClaim} from "src/SwellAirdropClaim.sol";
import {SwellAirdropClaimSolady} from "src/SwellAirdropClaimSolady.sol";
import {SwellAirdropClaimSolmate} from "src/SwellAirdropClaimSolmate.sol";

import {MerkleTreeHelper} from "test/MerkleTreeHelper.sol";

contract SwellAirdropClaimTest is MerkleTreeHelper {
    MockERC20 public swell = new MockERC20("Swell DAO token", "SWELL", 18);
    SwellAirdropClaim public claim = new SwellAirdropClaim(0x0, address(swell));
    SwellAirdropClaimSolady public claimSolady = new SwellAirdropClaimSolady(0x0, address(swell));
    SwellAirdropClaimSolmate public claimSolmate = new SwellAirdropClaimSolmate(0x0, address(swell));

    address public immutable alice = makeAddr("alice");
    address public immutable bob = makeAddr("bob");
    address public immutable carol = makeAddr("carol");
    address public immutable dave = makeAddr("dave");

    uint256 public constant TOTAL_AIRDROP = 1_000_000e18;

    function setUp() public {
        bytes32 root = getRoot();
        claim.setMerkleRoot(root);
        claimSolady.setMerkleRoot(root);
        claimSolmate.setMerkleRoot(root);
    }

    modifier sendTokenToMerkle(uint256 _amount) {
        swell.mint(address(claim), _amount);
        _;
    }

    /*
    function test_ClaimAirDrop_Alice() public sendTokenToMerkle(TOTAL_AIRDROP) {
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

    function test_RevertWhen_NoTokenOnContract() public {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);

        vm.expectRevert();
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);
    }

    function test_RevertWhen_AlreadyClaimed() public sendTokenToMerkle(TOTAL_AIRDROP) {
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

    function test_RevertWhen_ProofIsInvalid() public {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);
        // Modify proof
        proof[0] = bytes32("123");

        // Claim Airdrop
        vm.expectRevert("Invalid proof");
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);
    }

    function test_RevertWhen_AmountIsInvalid() public {
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

    function test_RevertWhen_IndexIsInvalid() public {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);
        // Modify index
        index += 1;

        // Claim Airdrop
        vm.expectRevert("Invalid proof");
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);
    }

    function test_RevertWhen_WrongCaller() public sendTokenToMerkle(TOTAL_AIRDROP) {
        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);

        // Claim Airdrop
        vm.expectRevert("Invalid proof");
        vm.prank(bob);
        claim.claimAirDrop(proof, index, amount);
    }*/

    function test_GasComparison() public {
        swell.mint(address(claim), TOTAL_AIRDROP);
        swell.mint(address(claimSolady), TOTAL_AIRDROP);
        swell.mint(address(claimSolmate), TOTAL_AIRDROP);

        // Get Proof
        (uint256 indexA, uint256 amountA, bytes32[] memory proofA) = getProof(alice);
        (uint256 indexB, uint256 amountB, bytes32[] memory proofB) = getProof(bob);
        (uint256 indexC, uint256 amountC, bytes32[] memory proofC) = getProof(carol);
        (uint256 indexD, uint256 amountD, bytes32[] memory proofD) = getProof(dave);

        // Claim Airdrop using Openzeppelin MerkleProof
        vm.prank(alice);
        claim.claimAirDrop(proofA, indexA, amountA);
        vm.prank(bob);
        claim.claimAirDrop(proofB, indexB, amountB);
        vm.prank(carol);
        claim.claimAirDrop(proofC, indexC, amountC);
        vm.prank(dave);
        claim.claimAirDrop(proofD, indexD, amountD);

        // Claim Airdrop using Solmate MerkleProof
        vm.prank(alice);
        claimSolmate.claimAirDrop(proofA, indexA, amountA);
        vm.prank(bob);
        claimSolmate.claimAirDrop(proofB, indexB, amountB);
        vm.prank(carol);
        claimSolmate.claimAirDrop(proofC, indexC, amountC);
        vm.prank(dave);
        claimSolmate.claimAirDrop(proofD, indexD, amountD);

        // Claim Airdrop using Solady MerkleProof
        vm.prank(alice);
        claimSolady.claimAirDrop(proofA, indexA, amountA);
        vm.prank(bob);
        claimSolady.claimAirDrop(proofB, indexB, amountB);
        vm.prank(carol);
        claimSolady.claimAirDrop(proofC, indexC, amountC);
        vm.prank(dave);
        claimSolady.claimAirDrop(proofD, indexD, amountD);
    }
}
