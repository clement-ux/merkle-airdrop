// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "./Base.t.sol";

contract GasComparison is BaseTest {
    bytes32 public root;

    function setUp() public {
        claim = new AirdropClaim(0x0, address(token));
        claim1Inch = new AirdropClaim1Inch(address(token));
        claimSolady = new AirdropClaimSolady(0x0, address(token));
        claimSolmate = new AirdropClaimSolmate(0x0, address(token));

        root = getRoot();
        claim.setMerkleRoot(root);
        claim1Inch.setMerkleRoot(root);
        claimSolady.setMerkleRoot(root);
        claimSolmate.setMerkleRoot(root);
    }

    function test_GasComparison() public {
        token.mint(address(claim), TOTAL_AIRDROP);
        token.mint(address(claimSolady), TOTAL_AIRDROP);
        token.mint(address(claimSolmate), TOTAL_AIRDROP);
        token.mint(address(claim1Inch), TOTAL_AIRDROP);

        _openZeppelin();
        _solady();
        _solmate();
        _1inch();
    }

    function _openZeppelin() internal {
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
    }

    function _solady() internal {
        // Get Proof
        (uint256 indexA, uint256 amountA, bytes32[] memory proofA) = getProof(alice);
        (uint256 indexB, uint256 amountB, bytes32[] memory proofB) = getProof(bob);
        (uint256 indexC, uint256 amountC, bytes32[] memory proofC) = getProof(carol);
        (uint256 indexD, uint256 amountD, bytes32[] memory proofD) = getProof(dave);

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

    function _solmate() internal {
        // Get Proof
        (uint256 indexA, uint256 amountA, bytes32[] memory proofA) = getProof(alice);
        (uint256 indexB, uint256 amountB, bytes32[] memory proofB) = getProof(bob);
        (uint256 indexC, uint256 amountC, bytes32[] memory proofC) = getProof(carol);
        (uint256 indexD, uint256 amountD, bytes32[] memory proofD) = getProof(dave);

        // Claim Airdrop using Solmate MerkleProof
        vm.prank(alice);
        claimSolmate.claimAirDrop(proofA, indexA, amountA);
        vm.prank(bob);
        claimSolmate.claimAirDrop(proofB, indexB, amountB);
        vm.prank(carol);
        claimSolmate.claimAirDrop(proofC, indexC, amountC);
        vm.prank(dave);
        claimSolmate.claimAirDrop(proofD, indexD, amountD);
    }

    function _1inch() internal {
        // Get Proof
        (uint256 indexA, uint256 amountA, bytes32[] memory proofA) = getProof(alice);
        (uint256 indexB, uint256 amountB, bytes32[] memory proofB) = getProof(bob);
        (uint256 indexC, uint256 amountC, bytes32[] memory proofC) = getProof(carol);
        //(uint256 indexD, uint256 amountD, bytes32[] memory proofD) = getProof(dave);

        // Claim Airdrop using 1Inch MerkleProof
        vm.prank(alice);
        claim1Inch.claim(alice, amountA, root, proofA, indexA);
        vm.prank(bob);
        claim1Inch.claim(bob, amountB, root, proofB, indexB);
        vm.prank(carol);
        claim1Inch.claim(carol, amountC, root, proofC, indexC);
        //vm.prank(dave);
        //claim1Inch.claim(dave, amountD, proofD, indexD);
    }
}
