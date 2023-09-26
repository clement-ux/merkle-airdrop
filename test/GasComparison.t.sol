// SPDX-License-Identifier: UNLICENSED
import "test/SwellAirdropClaim.t.sol";

contract GasComparison is SwellAirdropClaimTest {
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
