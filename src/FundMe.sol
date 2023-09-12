// SPDX-License-Identifier: MIT

/*
This is the main FundMe contract. It allows users to fund the contract and the contract owner to withdraw the funds.

Key Features:

1. FundMe: The main contract that holds all the logic. It uses the PriceConverter library to convert Ether to USD.

2. fund: A function that allows users to send Ether to the contract. The function checks if the sent Ether is more than a minimum USD amount using a Chainlink price feed.

3. cheaperWithdraw and withdraw: Functions that allow the contract owner to withdraw all funds from the contract. They also reset the funding amounts for all funders and clear the funder list.

4. fallback and receive: Functions that are called when the contract receives Ether without a function call. They simply call the fund function.

5. Getters: Functions that allow you to get information about the contract state, such as the amount funded by a specific address, a funder from the list of funders, the contract owner, and the version of the Chainlink price feed.

This contract is a simple crowdfunding contract where users can fund it with Ether and the owner can withdraw the funds.
*/
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] public s_funders;

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    AggregatorV3Interface private s_priceFeed; // Chainlink price feed interface

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed); // Initialize Chainlink price feed
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Insufficient ETH provided in USD."
        );

        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    // cheaperWithdraw function: This function allows the contract owner to withdraw all funds from the contract.
    // It first resets the funding amounts for all funders and clears the funder list more efficiently by storing the length of the funder list in a variable.
    // It then sends all the contract's balance to the owner.
    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        // Withdraw contract balance to the owner
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Withdrawal failed.");
    }

    // withdraw function: This function is similar to cheaperWithdraw but it does not store the length of the funder list in a variable.
    // This means it could potentially be more expensive in terms of gas costs if the funder list is large.
    // It also sends all the contract's balance to the owner.
    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        // Withdraw contract balance to the owner
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Withdrawal failed.");
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    // Getters

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getPriceFeedVersion() external view returns (uint256) {
        return s_priceFeed.version(); // Get the Chainlink price feed version
    }
}
