🚀 Welcome aboard, Spaceman! 🚀

As a crypto enthusiast navigating the vast universe of DeFi, you need a reliable spaceship equipped with the most advanced tools. Our project is designed to be your trusted companion in this journey, enhancing your DeFi experience by making it smoother and safer. Here's a detailed overview of our project, categorized by each integration:

[Mask](#mask)

[Wormhole](#wormhole)

[XMTP](#xmtp)

[Push Protocol](#push-protocol)

[Gnosis Safe](#gnosis-safe)

[Uniswap](#uniswap)

[Spark Lend](#spark-lend)

[Hyperlane](#hyperlane)

[ApeCoin](#apecoin)

[zkEVM](#zkevm)

[Scroll](#scroll-testnet)

[Mantle](#mantle)

[Filecoin Virtual Machine](#filecoin-virtual-machine)

[The Graph](#the-graph)

[Connext](#connext)

[Compound](#compound)

[Polygon zkEVM](#polygon-zkevm)


## Mask
Our user interface, designed like a spaceship command center, provides an immersive and interactive experience. It leverages the Mask/NextId RelationService API for fetching user's information and facilitates real-time communication within the interface. This integration has made it easier to search for users, enhancing the overall user experience.

Related code in 
[src/components/CadetNamePanel.tsx](src/components/CadetNamePanel.tsx)
[src/components/XmtpChat.tsx](src/components/XmtpChat.tsx)

## Wormhole
Wormhole is a cross-chain bridge enabling communication between different blockchain networks. The WormholeProcessor contract processes these cross-chain messages. It keeps a list of approved senders for each chain, processing only messages from these senders, enhancing security.

The contract includes functions to add or remove approvers for a specific chain, allowing management of approved senders.

The `receiveWormholeMessages` function handles incoming messages from the Wormhole. It checks for message duplication, decodes the message, verifies the sender, and executes the transaction against the target.

In summary, the WormholeProcessor contract facilitates secure and efficient cross-chain communications.

[Tweet for submission](https://twitter.com/itspublu/status/1716063747679400027)

Related code: 
[hardhat/contracts/governance/WormholeProcessor.sol](hardhat/contracts/governance/WormholeProcessor.sol)
[hardhat/contracts/governance/ProposerExecutionZodiac.sol](hardhat/contracts/governance/ProposerExecutionZodiac.sol)

## XMTP
We've taken XMTP chat to the next level by creating a fork that works seamlessly with the Mask network. This feature allows users to search any connected social accounts and resolve them to an address which can be messaged. We've also integrated Privy, enabling users to conveniently login with their Apple and Google accounts and export their wallet directly from the website!

Direct link to demo: [https://xmtp-inbox-web-with-privy-git-dev-theqidaoteam.vercel.app/](https://xmtp-inbox-web-with-privy-git-dev-theqidaoteam.vercel.app/)

related code (integration to the space cabin): [src/components/XmtpChat.tsx](src/components/XmtpChat.tsx)
[https://github.com/publu/xmtp-inbox-web-privy/tree/dev](https://github.com/publu/xmtp-inbox-web-privy/tree/dev)

## Hyperlane
We've developed a Hyperlane proposer contract that enhances the cross-chain communication capabilities of our project. This contract processes messages from the Hyperlane cross-chain bridge, allowing for more complex and versatile transactions.

Related code:
[hardhat/contracts/governance/HyperlaneProcessor.sol](hardhat/contracts/governance/HyperlaneProcessor.sol)
[hardhat/contracts/governance/ProposerExecutionZodiac.sol](hardhat/contracts/governance/ProposerExecutionZodiac.sol)

## Filecoin Virtual Machine
We've innovatively incorporated on-chain achievements into our `Mintable.sol` contract. This enables the creation of unique achievements related to balance, farming, and borrowing. It's all self-service, eliminating the need for trust-based airdrops. Plus, it's fully interoperable, allowing anyone who connects to NFTs to participate. This game-changing feature makes the DeFi space more engaging and rewarding for users. We've also integrated achievements for Filecoin Virtual Machine holders. Prove you own some Filecoin to earn the NFT!

[hardhat/contracts/achievements/Mintable.sol](hardhat/contracts/achievements/Mintable.sol)

Here's the NFT we created
![Filecoin Virtual Machine](images/fvm.png)

## Gnosis Safe
We've developed a module for Connext that enables safes to send messages across chains. This cross-chain communication enhances the functionality of Gnosis Safe by allowing for more complex and versatile transactions.
In addition to the Connext module, we've also created a module for Hyperlane, further expanding the cross-chain capabilities of Gnosis Safe.
We also rewrote the old proposer module (included for visibility) into a Zodiac-enabled module. It was definitely a trip. Didn't realize how different the architecture was from a monolithic module.

Related code:
[hardhat/contracts/governance/ConnextProcessor.sol](hardhat/contracts/governance/ConnextProcessor.sol)
[hardhat/contracts/governance/HyperlaneProcessor.sol](hardhat/contracts/governance/HyperlaneProcessor.sol)
[hardhat/contracts/governance/ProposerExecutionZodiac.sol](hardhat/contracts/governance/ProposerExecutionZodiac.sol)

## Connext
We've integrated Connext, a modular interoperability protocol that lets you build secure crosschain dApps (xApps). We've created a Gnosis Safe connector module that lets safes communicate between chains using Connext as a bridge.

Related code:
[hardhat/contracts/governance/ConnextProcessor.sol](hardhat/contracts/governance/ConnextProcessor.sol)
[hardhat/contracts/governance/ProposerExecutionZodiac.sol](hardhat/contracts/governance/ProposerExecutionZodiac.sol)

## The Graph
We've deployed a subgraph for the NFT achievements. You can explore it [here](https://thegraph.com/studio/subgraph/achievements/).

Achievements are a unique feature we've incorporated into our project. They are designed to reward users for their on-chain activities. Achievements are tied to specific actions such as maintaining a certain balance, farming, or borrowing. They are fully self-service and interoperable, meaning anyone who connects to NFTs can participate. This feature adds an exciting layer of gamification to the DeFi experience, making it more engaging and rewarding for users.


## Push Protocol
We've integrated the Push Protocol to add push chat and calling features. Now, you can initiate a chat or a call with just a click of a button.

Related code:
[src/App.tsx](src/App.tsx)

## Gnosis Safe
We've enhanced our governance module by integrating the Connext bridge for cross-chain communications within the Gnosis Safe. This pivotal upgrade allows safes to send messages to each other across different chains and execute cross-chain transactions, thereby significantly improving the efficiency and versatility of governance protocols.

Related code:
[hardhat/contracts/governance/ConnextProcessor.sol](hardhat/contracts/governance/ConnextProcessor.sol)

## Compound
In our quest to make DeFi more engaging and rewarding, we've innovatively incorporated on-chain achievements into our `Mintable.sol` contract specifically for Compound. This feature enables users to earn unique NFTs based on their positions on Compound, adding an exciting layer of gamification to the DeFi experience. 

In addition to the features mentioned, we've introduced performance tokens and enabled CDP stablecoins such as MIM or MAI to be used as collateral in their 0% lending strategies. These tokens are designed to take a performance fee off the interest-bearing tokens across various protocols. This unique feature is not confined to our platform but extends to other DeFi protocols as well, enhancing interoperability and enriching the user experience in the DeFi space.

Related code in 
[hardhat/contracts/achievements/Mintable.sol](hardhat/contracts/achievements/Mintable.sol)
[hardhat/contracts/lending/PerformanceTokensV2.sol](hardhat/contracts/lending/PerformanceTokensV2.sol)
[hardhat/contracts/achievements/Mintable_CompoundStrategy.sol](hardhat/contracts/achievements/Mintable_CompoundStrategy.sol)

## Uniswap
Our liquidation engine works with Stability MAI (sMAI for short). It uses user-staked MAI to liquidate loans and uses UniswapV4 hooks to sell the collateral at a certain MAI price. This integration into the stability pool of MAI allows the stability pool contract to sell into Uniswap when the price is acceptable.

Related code:
[hardhat/contracts/liquidation/storefront.sol](hardhat/contracts/liquidation/storefront.sol)

## Polygon zkEVM
We've deployed an innovative NFT achievements contract on the Polygon zkEVM network. This contract allows users to earn unique NFTs based on their on-chain activities, adding an exciting layer of gamification to the DeFi experience. We've also created a demo and custom artwork specifically for ETH holders on zkEVM, further enhancing the user experience and engagement. This integration not only rewards users for their participation but also fosters a sense of community and achievement among them.

[hardhat/contracts/achievements/ipfs/zkevm.json](hardhat/contracts/achievements/ipfs/zkevm.json)
[hardhat/contracts/achievements/Mintable.sol](hardhat/contracts/achievements/Mintable.sol)

![Polygon zkEVM ETH Holders](images/zkevm_holder.png)

## Spark Lend
Our versatile contract uses interest-bearing assets as collateral in lending protocols. It's compatible with SparkLend, the erc4626 sDAI, and also works with Compound lending. Protocols integrating with us get a cut of the earnings, making it a win-win situation for all.

We also integrated Sparklend tokens as a strategy for our on chain achievements contract. This lets users claim NFTs based on their activity in Sparklend (ie: borrowing or depositing)

Related code:
[hardhat/contracts/achievements/Mintable.sol](hardhat/contracts/achievements/Mintable.sol)
[hardhat/contracts/achievements/Mintable_SparkLend_Strategy.sol](hardhat/contracts/achievements/Mintable_SparkLend_Strategy.sol)
[hardhat/contracts/lending/PerformanceTokensV2.sol](hardhat/contracts/lending/PerformanceTokensV2.sol)


## ApeCoin
We've innovatively incorporated on-chain achievements into our `Mintable.sol` contract. This enables the creation of unique achievements related to balance, farming, and borrowing. It's all self-service, eliminating the need for trust-based airdrops. Plus, it's fully interoperable, allowing anyone who connects to NFTs to participate. This game-changing feature makes the DeFi space more engaging and rewarding for users. We've also integrated achievements for ApeCoin holders. Prove you own some ApeCoin to earn the NFT!

related code:
[hardhat/contracts/achievements/ipfs/apecoin.json](hardhat/contracts/achievements/ipfs/apecoin.json)
[hardhat/contracts/achievements/Mintable.sol](hardhat/contracts/achievements/Mintable.sol)

## Scroll Testnet
We've deployed an NFT achievements contract to let users earn NFTs for their on-chain activity. We've created a demo and art for ETH holders on Scroll Testnet. You can view the contract [https://sepolia.scrollscan.dev/address/0xDD8EAB7d0b12df6faFAd27e14FEa446e40b4d98E#contracts](https://sepolia.scrollscan.dev/address/0xDD8EAB7d0b12df6faFAd27e14FEa446e40b4d98E#contracts).

Related code:
[hardhat/contracts/achievements/Mintable.sol](hardhat/contracts/achievements/Mintable.sol)
[hardhat/contracts/achievements/ipfs/scroll.json](hardhat/contracts/achievements/ipfs/scroll.json)

![Scroll Testnet ETH Holders](images/scroll_eth.jpg)

## Mantle
We've deployed an NFT achievements contract to let users earn NFTs for their on-chain activity. We've created a demo and art for MNT holders on Mantle.
[https://explorer.mantle.xyz/address/0xFf0756582c66D59F3C1bd413F7D0A720c99B9992](https://explorer.mantle.xyz/address/0xFf0756582c66D59F3C1bd413F7D0A720c99B9992)

Tweet submission:
[https://twitter.com/itspublu/status/1716063374617067913](https://twitter.com/itspublu/status/1716063374617067913)

Related code:
[hardhat/contracts/achievements/ipfs/mantle.json](hardhat/contracts/achievements/ipfs/mantle.json)
[hardhat/contracts/achievements/Mintable.sol](hardhat/contracts/achievements/Mintable.sol)

![Mantle MNT Holders](images/mantle_holders.png)

Our codebase also includes contracts and interfaces for vaults and liquidators, among other features. We hope this detailed overview helps you understand our project better!

