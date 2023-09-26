// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "forge-std/Test.sol";

import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {SwellAirdropClaim} from "src/SwellAirdropClaim.sol";

import {GetProof} from "test/getProof.sol";

contract SwellAirdropClaimTest is GetProof {
    MockERC20 public swell = new MockERC20("Swell DAO token", "SWELL", 18);
    SwellAirdropClaim public claim = new SwellAirdropClaim(0x0, address(swell));

    address public immutable alice = makeAddr("alice");
    address public immutable bob = makeAddr("bob");

    modifier setMerkelRoot() {
        claim.setMerkleRoot(getRoot());
        _;
    }

    modifier sendTokenToMerkle(uint256 _amount) {
        swell.mint(address(claim), _amount);
        _;
    }

    function test_ClaimAirDrop_Alice() public setMerkelRoot sendTokenToMerkle(30e18) {
        // Check before
        assertEq(swell.balanceOf(alice), 0);

        // Get Proof
        (uint256 index, uint256 amount, bytes32[] memory proof) = getProof(alice);

        // Claim Airdrop
        vm.prank(alice);
        claim.claimAirDrop({proof: proof, index: index, amount: amount});

        // Check after
        assertEq(swell.balanceOf(alice), 10e18);
    }
}
