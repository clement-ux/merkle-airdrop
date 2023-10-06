// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "forge-std/Test.sol";

import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {AirdropClaim} from "src/AirdropClaim.sol";
import {AirdropClaim1Inch} from "src/AirdropClaim1Inch.sol";
import {AirdropClaimSolady} from "src/AirdropClaimSolady.sol";
import {AirdropClaimSolmate} from "src/AirdropClaimSolmate.sol";

import {MerkleTreeHelper} from "test/MerkleTreeHelper.sol";

contract BaseTest is MerkleTreeHelper {
    MockERC20 public token = new MockERC20("Token", "TKN", 18);
    AirdropClaim public claim;
    AirdropClaim1Inch public claim1Inch;
    AirdropClaimSolady public claimSolady;
    AirdropClaimSolmate public claimSolmate;

    address public immutable alice = makeAddr("alice");
    address public immutable bob = makeAddr("bob");
    address public immutable carol = makeAddr("carol");
    address public immutable dave = makeAddr("dave");

    uint256 public constant TOTAL_AIRDROP = 1_000_000e18;
}
