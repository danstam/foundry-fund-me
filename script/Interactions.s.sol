// SPDX-License-Identifier: MIT

/*
This script contains two contracts: FundFundMe and WithdrawFundMe, which are used to interact with the FundMe contract.

1. FundFundMe: This contract is used to fund the FundMe contract. It sends a fixed amount of Ether to the FundMe contract's fund function.

2. WithdrawFundMe: This contract is used to withdraw funds from the FundMe contract.

Both contracts use the run function to execute their respective operations. These contracts simulate the actions a user might take in a live environment, acting as a remote control for the FundMe contract.
*/

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();

        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
