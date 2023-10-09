// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "./Base.t.sol";

contract GasComparison is BaseTest {
    bytes32 public root;

    address[] public addresses;
    uint256[] public amounts;
    uint256 public totalAmount;

    function setUp() public {
        claim = new AirdropClaim(0x0, address(token));
        claim1Inch = new AirdropClaim1Inch(0x0, address(token));
        claimSolady = new AirdropClaimSolady(0x0, address(token));
        claimSolmate = new AirdropClaimSolmate(0x0, address(token));
        gasLite = new GasLite();

        root = getRoot();
        claim.setMerkleRoot(root);
        claim1Inch.setMerkleRoot(root);
        claimSolady.setMerkleRoot(root);
        claimSolmate.setMerkleRoot(root);

        for (uint256 i; i < 20_000; i++) {
            addresses.push(makeAddr(vm.toString(i)));
            amounts.push(1e18);
            totalAmount += 1e18;
        }
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

    // 501_566_739
    function test_GasLite() public {
        token.mint(address(this), TOTAL_AIRDROP);
        token.approve(address(gasLite), TOTAL_AIRDROP);
        gasLite.airdropERC20(address(token), addresses, amounts, totalAmount);
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
        (uint256 indexD, uint256 amountD, bytes32[] memory proofD) = getProof(dave);

        // Claim Airdrop using 1Inch MerkleProof
        vm.prank(alice);
        claim1Inch.claimAirDrop(proofA, indexA, amountA);
        vm.prank(bob);
        claim1Inch.claimAirDrop(proofB, indexB, amountB);
        vm.prank(carol);
        claim1Inch.claimAirDrop(proofC, indexC, amountC);
        vm.prank(dave);
        claim1Inch.claimAirDrop(proofD, indexD, amountD);
    }
}
