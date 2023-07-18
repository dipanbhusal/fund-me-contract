// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {YoFundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    // FIRST STEP: deploy the contract
    // first step to start script
    function run() external returns (YoFundMe) {
        // start broadcasting process
        vm.startBroadcast();

        // create new instance of the contract
        YoFundMe fundMe = new YoFundMe(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );

        // terminate broadcasting process
        vm.stopBroadcast();
        return fundMe;
    }
}
