# Foundry Fund Me Project



Welcome to my Foundry Fund Me project! This repository marks the beginning of a series of projects I'll be sharing to showcase my skills and experience as a blockchain developer. 

## Project Overview

- **Objective:** This project demonstrates a Fund Me contract where the contract owner can receive contributions from various addresses and execute secure fund withdrawals.
- **Key Features:**
  - Thorough unit and fork testing using the Foundry framework
  - Gas optimization for efficient blockchain interactions.
  - Integration with a chainlink price feed for offchain currency conversion.





## Requirements

1. **Git Installation**

   If Git is not already installed on your system, please follow the detailed installation instructions [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

2. **Foundry Installation**

   If Foundry is not already installed on your system, you can obtain it by running [this](https://getfoundry.sh/) command.

   ## Getting Started
   To access and set up this project, follow these steps:

   1. **Clone the Repository:** Use the following command to create a local copy of the project on your computer:
   
```
git clone https://github.com/danstam/foundry-fund-me.git

```
2. **Navigate to the Project Directory:** The following command will take you into the newly cloned project directory:
```
cd foundry-fund-me
```


3. **Build the Project:** Finally, build the project by running the following command:
```
forge build  
```




## Deployment

### Deploying to a Simulated Enviroment


 To deploy the Fund Me contract to a local **simulated Anvil chain** (safer and simpler), you can use the following Forge script:

```
forge script script/DeployFundMe.s.sol
```
 ### Deploying to a Testnet or Mainnet

Before deploying your smart contract to a testnet or mainnet, you'll need to set up some environment variables. Follow these steps:

### Environment Variables Setup

1. Create a `.env` file in your project directory.

2. Define the following environment variables in your `.env` file:

   - `PRIVATE_KEY`: Your account's private key (e.g., from Metamask). **Note**: For development, it's crucial to use a key with no real funds associated with it. 

   - `SEPOLIA_RPC_URL`: The URL of the Sepolia testnet node we are working with. You can obtain a free testnet node from [Alchemy](https://www.alchemy.com/).
     
    

   - Optionally, if you wish to verify your contract on Etherscan, you can also add:

     - `ETHERSCAN_API_KEY`: Your Etherscan API key.

### Obtaining Testnet ETH

The last step is to Visit [faucets.chain.link](https://faucets.chain.link) to request some testnet ETH. This will provide you with the necessary test Ethereum for deployment and testing purposes. You should see the test ETH reflected in your [Metamask](https://support.metamask.io/hc/en-us/articles/360015489531-Getting-started-with-MetaMask) wallet.



 ### Now that your environment is set up, you're ready to deploy the contract. Execute the deployment script with the following command:

```
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```













## Testing

### Comprehensive Tests


To perform a comprehensive test of all functions in the contract, use the following command:
```
forge test
```
This command will run all test cases defined in the test files.
### Specific Function Tests


If you want to test a specific function, you can use the `--match-test`  flag followed by the function name. For example:


```
forge test --match-test <function_name_goes_here>

```
### Testing on a Forked Sepolia Testnet:
```
forge test --fork-url $SEPOLIA_RPC_URL

```
This command will run the tests on a fork of the Sepolia testnet, providing a realistic testing environment without affecting the actual network. 

To see a test coverage overview, run:
```
forge coverage
```
This command generates a coverage report that shows which parts of the contract code are covered by the tests. It's a useful tool for identifying areas of your contract that may need additional testing.


## Gas Estimate

When you execute the following command:
```
forge snapshot
```
It will generate a comprehensive gas snapshot report in a new file. This report will provide a breakdown of gas consumption for various operations, giving you a clear overview of the cost associated with each action




