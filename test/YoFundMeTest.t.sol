// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {YoFundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract YoFundMeTest is Test {
    YoFundMe fundMeContract;

    // FIRST STEP: deploy the contract for the test
    // first step to write tests
    function setUp() external {
        // deploy the contract
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMeContract = deployFundMe.run();
    }

    // test for checking if minimum fund requirement is 5 USD
    function testMinimumFundRequirement() public {
        assertEq(fundMeContract.MINIMUM_USD(), 5e18);
    }

    // test for checking if owner of contract is the one who deployed it
    function testOwnerIsMessageSender() public {
        // here YoFundMeTest is the owner of the contract
        assertEq(fundMeContract.i_owner(), msg.sender);
    }

    // test for checking if the price feed version is 4
    function testPriceFeedVersion() public {
        uint256 priceFeedVersion = fundMeContract.getFeedVersion();

        assertEq(priceFeedVersion, 4);
    }
}
