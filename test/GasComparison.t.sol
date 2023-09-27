// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "test/SwellAirdropClaim.t.sol";

import {AirdropClaimSolady} from "src/SwellAirdropClaimSolady.sol";
import {AirdropClaimSolmate} from "src/SwellAirdropClaimSolmate.sol";

contract GasComparison is AirdropClaimTest {
    AirdropClaimSolady public claimSolady = new AirdropClaimSolady(0x0, address(token));
    AirdropClaimSolmate public claimSolmate = new AirdropClaimSolmate(0x0, address(token));

    function setUp() public override {
        super.setUp();
        claimSolady.setMerkleRoot(root);
        claimSolmate.setMerkleRoot(root);
    }

    function test_GasComparison() public {
        token.mint(address(claim), TOTAL_AIRDROP);
        token.mint(address(claimSolady), TOTAL_AIRDROP);
        token.mint(address(claimSolmate), TOTAL_AIRDROP);

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
