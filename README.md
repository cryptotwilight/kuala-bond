# Kuala Bond 
Kuala means "muddy confluence" or "meeting of the waters" in Malay. With this is mind we have created the Kuala Bond project. The purpose of the project is to enable cross chain efficiency through the use of cross chain bonds. 

## The Problem 
Current crypto mechanics dictate that liquid capital has to be physically transferred from one chain to another for it to be used in various protocols such as DeFi. This represents an issue as most chains won't have the same or even equivalent projects e.g. oracles, cryptocurrencies etc, and for projects the overhead of a presence on every chain is financially, operationally and technically a highly non-trivial endeavour. 

## The Solution 
Enter Kuala Bonds. Kuala Bonds enable capital used as collateral across chains even where the collateral token is not hosted or known. By creating a bond on the native chain for the token, this bond can then be teleported to any Kuala Bond supported chains where the bond holder is then enabled to access local capital through Kuala Bond pools. Kuala Bond Pools are a DeFi primitive that uses bonds as collateral against chain local currency loans. This enables Kuala Bond users to access a wide variety of chains and tokens without having to leave the comfort of their local chain community or put their currency at risk in the bridging process. 

## How it works 
Kuala Bonds work by using a Kuala Bond Contract that works with NFT mechanics. The Kuala Bond is represented as an NFT however it's details are kept on chain. Both the Kuala Bond Contract and the Kuala Bond have to be registered prior to any movement cross chain. Once registered the bond holder is able to teleport the Kuala Bond to any supported chain. The bond is transmitted to the wallet of the bond holder on the destination chain ensuring full control. The bond holder is then able to stake their Kuala Bond in a Kuala Bond Pool which gives them access to local chain tokens through loans from the pool.  

## Deployments
The following are the chain deployments for the project 
The project is deployed on 
- Scroll Sepolia Testnet
- FVM Testnet
- Polygon Testnet 

|Chain                 |Chain Id| Contract            | Address                                   | Verification |Description | 
|----------------------|--------|---------------------|-------------------------------------------|--------------|------------|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Test Token|0xd2365C8E4C3548ddd02184bac8b236408b47391a | [https://sepolia.scrollscan.dev/address/0xd2365C8E4C3548ddd02184bac8b236408b47391a#code](https://sepolia.scrollscan.dev/address/0xd2365C8E4C3548ddd02184bac8b236408b47391a#code) | This is the liquidity token for the kuala bond pool |
|Scroll Sepolia Testnet| 534351 |Kuala Bond Test Reward Token|[https://sepolia.scrollscan.dev/address/0x479fA5A325774dED40e56351F681988Dc6165B36#code](https://sepolia.scrollscan.dev/address/0x479fA5A325774dED40e56351F681988Dc6165B36#code)| This is the reward token for Kuala Bond pool liquidity providers |
|Scroll Sepolia Testnet| 534351 |Ops Register|0x38872A6AfD9a2Ea0d027920679F8110f0155d1fC|0x479fA5A325774dED40e56351F681988Dc6165B36|[https://sepolia.scrollscan.dev/address/0x38872A6AfD9a2Ea0d027920679F8110f0155d1fC#code](https://sepolia.scrollscan.dev/address/0x38872A6AfD9a2Ea0d027920679F8110f0155d1fC#code)| This is the dApp operational register for main  |
|Scroll Sepolia Testnet| 534351 |Kuala Bond Pool|0x37763B7bC86E683B0E134Ce39bF2A160894Fddc2|              		 | This is the Kuala Bond Pool that accepts Kuala Bonds against currencies like APE and sDAI in exchange for loands of Kuala Bond Tokens|
|Scroll Sepolia Testnet| 534351 |KB Routing Registry|0xa07DF0c10415086600CE581363AEBDe715734edF|              	 | |
|Scroll Sepolia Testnet| 534351 |KB Synthetic Factory|0xa7898B80483d3E942ec30A1F68Dca600AF790af3|              	 | |
|Scroll Sepolia Testnet| 534351 |Kuala Bond Contract |0xE6f3C737081Df078BbDD1cEE921802264b04b39f|              	 | This is the Kuala Bond Contract for Kuala Bond Token bonds|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Vault|0xF3aA1be10644577655584108e16441379d2c517D|            		 | This is the Vault where teleported bonds are commited|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Register|0x7F39aCc609B4d459821f07142d165a454D6b6637|              	 | This is the register for all Kuala Bonds on the local chain, only Registered Kuala Bonds can be teleported|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Teleporter|0xABBD4228Fd397946E08656f05B3A83f8C37323f7|               | This is the teleporter that moves Kuala Bonds between chains using the Axelar protocol|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Recciever |0x40B3EE902182b830a12Ebd7FAAe8Bc680B751269|               | This is the teleport reciever that recieves transmitted Kuala Bonds and materialises them on chain|


|Scroll| 534351 |          |         |              ||
|Scroll| 534351 |          |         |              ||