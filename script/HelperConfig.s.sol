// SPDX-LINCENSE-IDENTIFIER:
pragma solidity ^0.8.18;

/*
This script contains the HelperConfig contract which is used to manage network configurations for the FundMe contract.

1. NetworkConfig: A struct that holds the address of the price feed for the network.

2. HelperConfig: This contract sets the active network configuration based on the chain ID. It has two main functions:

   - getSepoliaEthConfig: Returns the network configuration for the Sepolia network.
   
   - getOrCreateAnvilEthConfig: Returns the existing network configuration for the Anvil network, or creates a new one if it doesn't exist.

The contract is designed to provide the correct price feed address for different Ethereum networks.
*/

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
