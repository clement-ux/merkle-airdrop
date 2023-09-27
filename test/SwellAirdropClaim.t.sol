// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "forge-std/Test.sol";

import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {AirdropClaim} from "src/SwellAirdropClaim.sol";
import {AirdropClaimSolady} from "src/SwellAirdropClaimSolady.sol";
import {AirdropClaimSolmate} from "src/SwellAirdropClaimSolmate.sol";

import {MerkleTreeHelper} from "test/MerkleTreeHelper.sol";

contract AirdropClaimTest is MerkleTreeHelper {
    MockERC20 public token = new MockERC20("Token", "TKN", 18);
    AirdropClaim public claim = new AirdropClaim(0x0, address(token));

    address public immutable alice = makeAddr("alice");
    address public immutable bob = makeAddr("bob");
    address public immutable carol = makeAddr("carol");
    address public immutable dave = makeAddr("dave");

    uint256 public constant TOTAL_AIRDROP = 1_000_000e18;

    bytes32 public root;

    function setUp() public virtual {
        root = getRoot();
        claim.setMerkleRoot(root);
    }

    modifier sendTokenToMerkle(uint256 _amount) {
        token.mint(address(claim), _amount);
        _;
    }

    function test_ClaimAirDrop_Alice() public sendTokenToMerkle(TOTAL_AIRDROP) {
        // Check before
        assertEq(token.balanceOf(alice), 0);

        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);

        // Claim Airdrop
        vm.prank(alice);
        claim.claimAirDrop(proof, index, amount);

        // Check after
        assertEq(token.balanceOf(alice), amount);
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
    }
}
