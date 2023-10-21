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

- Goerli Testnet (Bond & Settlement Only)
- Scroll Sepolia Testnet
- FVM Testnet
- Polygon Testnet

  

|Chain |Chain Id| Contract | Address | Verification |Description |
|----------------------|--------|---------------------|-------------------------------------------|--------------|------------|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Test Token|0xd2365C8E4C3548ddd02184bac8b236408b47391a | [https://sepolia.scrollscan.dev/address/0xd2365C8E4C3548ddd02184bac8b236408b47391a#code](https://sepolia.scrollscan.dev/address/0xd2365C8E4C3548ddd02184bac8b236408b47391a#code) | This is the liquidity token for the kuala bond pool |
|Scroll Sepolia Testnet| 534351 |Kuala Bond Test Reward Token|0x479fA5A325774dED40e56351F681988Dc6165B3|[https://sepolia.scrollscan.dev/address/0x479fA5A325774dED40e56351F681988Dc6165B36#code](https://sepolia.scrollscan.dev/address/0x479fA5A325774dED40e56351F681988Dc6165B36#code)| This is the reward token for Kuala Bond pool liquidity providers |
|Scroll Sepolia Testnet| 534351 |Ops Register|0x38872A6AfD9a2Ea0d027920679F8110f0155d1fC|[https://sepolia.scrollscan.dev/address/0x38872A6AfD9a2Ea0d027920679F8110f0155d1fC#code](https://sepolia.scrollscan.dev/address/0x38872A6AfD9a2Ea0d027920679F8110f0155d1fC#code)| This is the dApp operational register for main |
|Scroll Sepolia Testnet| 534351 |Kuala Bond Pool|0x37763B7bC86E683B0E134Ce39bF2A160894Fddc2|[https://sepolia.scrollscan.dev/address/0x37763B7bC86E683B0E134Ce39bF2A160894Fddc2#code](https://sepolia.scrollscan.dev/address/0x37763B7bC86E683B0E134Ce39bF2A160894Fddc2#code) | This is the Kuala Bond Pool that accepts Kuala Bonds against currencies like APE and sDAI in exchange for loands of Kuala Bond Tokens|
|Scroll Sepolia Testnet| 534351 |KB Routing Registry|0xa07DF0c10415086600CE581363AEBDe715734edF|[https://sepolia.scrollscan.dev/address/0xa07DF0c10415086600CE581363AEBDe715734edF#code](https://sepolia.scrollscan.dev/address/0xa07DF0c10415086600CE581363AEBDe715734edF#code) |Interchain secure routing map |
|Scroll Sepolia Testnet| 534351 |KB Synthetic Factory|0xa7898B80483d3E942ec30A1F68Dca600AF790af3|[https://sepolia.scrollscan.dev/address/0xa7898B80483d3E942ec30A1F68Dca600AF790af3#code](https://sepolia.scrollscan.dev/address/0xa7898B80483d3E942ec30A1F68Dca600AF790af3#code)|Synthetic Bond contract creation |
|Scroll Sepolia Testnet| 534351 |Kuala Bond Contract |0xE6f3C737081Df078BbDD1cEE921802264b04b39f|[https://sepolia.scrollscan.dev/address/0xE6f3C737081Df078BbDD1cEE921802264b04b39f#code](https://sepolia.scrollscan.dev/address/0xE6f3C737081Df078BbDD1cEE921802264b04b39f#code) | This is the Kuala Bond Contract for Kuala Bond Token bonds|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Vault|0xF3aA1be10644577655584108e16441379d2c517D|[https://sepolia.scrollscan.dev/address/0xF3aA1be10644577655584108e16441379d2c517D#code](https://sepolia.scrollscan.dev/address/0xF3aA1be10644577655584108e16441379d2c517D#code)| This is the Vault where teleported bonds are commited|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Register|0x5A12cb20c413aD0d73E62E8496B6fA166EeC4511|[https://sepolia.scrollscan.dev/address/0x5A12cb20c413aD0d73E62E8496B6fA166EeC4511#code](https://sepolia.scrollscan.dev/address/0x5A12cb20c413aD0d73E62E8496B6fA166EeC4511#code) | This is the register for all Kuala Bonds on the local chain, only Registered Kuala Bonds can be teleported|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Teleporter|0xABBD4228Fd397946E08656f05B3A83f8C37323f7|[https://sepolia.scrollscan.dev/address/0x591CE52f8aA7481DDeC9ad27ffe0B87b2C880B79#code](https://sepolia.scrollscan.dev/address/0x591CE52f8aA7481DDeC9ad27ffe0B87b2C880B79#code)| This is the teleporter that moves Kuala Bonds between chains using the Axelar protocol|
|Scroll Sepolia Testnet| 534351 |Kuala Bond Reciever |0x706d554eEAFE8381abE5fCcc14A3F30A7Ed48C08|[https://sepolia.scrollscan.dev/address/0x706d554eEAFE8381abE5fCcc14A3F30A7Ed48C08#code](https://sepolia.scrollscan.dev/address/0x706d554eEAFE8381abE5fCcc14A3F30A7Ed48C08#code)| This is the teleport reciever that recieves transmitted Kuala Bonds and materialises them on chain|
|Goerli|5|Ops Register|0xA828632816Da9d92f09B611e8fB39d57b98502e3 |[https://goerli.etherscan.io/address/0xA828632816Da9d92f09B611e8fB39d57b98502e3#code](https://goerli.etherscan.io/address/0xA828632816Da9d92f09B611e8fB39d57b98502e3#code) | Kuala Bond Operations Register on Goerli|
|Goerli|5|KBRoutingRegistry|0x10A66F5cB6Adea40FD196031f45Eb87D119B6167|[https://goerli.etherscan.io/address/0x10A66F5cB6Adea40FD196031f45Eb87D119B6167#code](https://goerli.etherscan.io/address/0x10A66F5cB6Adea40FD196031f45Eb87D119B6167#code)||
|Goerli|5|APE COIN - KUALA BOND Contract|0xf7d1154d9981762f3b259938480A48b54Ea5D65a|[https://goerli.etherscan.io/address/0xf7d1154d9981762f3b259938480A48b54Ea5D65a#code](https://goerli.etherscan.io/address/0xf7d1154d9981762f3b259938480A48b54Ea5D65a#code)||
|Goerli|5|Kaula Bond Synthetic Factory|0x21BeA81284fE44E91253837A930ea3AB6681e635|[https://goerli.etherscan.io/address/0x21BeA81284fE44E91253837A930ea3AB6681e635#code](https://goerli.etherscan.io/address/0x21BeA81284fE44E91253837A930ea3AB6681e635#code)||
|Goerli|5|Kuala Bond Register|0xbF4543DaE1990d1cC78E14e5db1a076fC63c0731|[https://goerli.etherscan.io/address/0xbF4543DaE1990d1cC78E14e5db1a076fC63c0731#code](https://goerli.etherscan.io/address/0xbF4543DaE1990d1cC78E14e5db1a076fC63c0731#code)||
|Goerli|5|Kuala Bond Vault|0x52bEC1792B3587dE0bB40f851fB08d69E971A1bC|[https://goerli.etherscan.io/address/0x52bEC1792B3587dE0bB40f851fB08d69E971A1bC#code](https://goerli.etherscan.io/address/0x52bEC1792B3587dE0bB40f851fB08d69E971A1bC#code)||
|Goerli|5|Kaula Bond Reciever|0x49cfDdfC3A62A38809640354a886c8f53094f507|[https://goerli.etherscan.io/address/0x49cfDdfC3A62A38809640354a886c8f53094f507#code](https://goerli.etherscan.io/address/0x49cfDdfC3A62A38809640354a886c8f53094f507#code)||
|Goerli|5|Kuala Bond Teleporter|0xE868dD6524DfE8Ab8AE45537Ad0647259C87D84c|[https://goerli.etherscan.io/address/0xE868dD6524DfE8Ab8AE45537Ad0647259C87D84c#code](https://goerli.etherscan.io/address/0xE868dD6524DfE8Ab8AE45537Ad0647259C87D84c#code)||
