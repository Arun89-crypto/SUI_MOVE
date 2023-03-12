# Sui Environment & Intro

## Environment

```sh
❯ sui client envs
Config file ["/Users/family/.sui/sui_config/client.yaml"] doesn't exist, do you want to connect to a Sui full node server [yN]?y
Sui full node server url (Default to Sui DevNet if not specified) : 
Select key scheme to generate keypair (0 for ed25519, 1 for secp256k1, 2: for secp256r1:
1

Generated new keypair for address with scheme "secp256k1" [0x15d2b782e1ab6130bb312c477439126c06ffb594]
Secret Recovery Phrase : [<S3CR3T_PHR4S3>]

devnet => https://fullnode.devnet.sui.io:443 (active)
```

Managing the networks

```sh
# switch network
sui client switch --env [network alias]

# adding new network
sui client new-env --alias <ALIAS> --rpc <RPC>
```

Managing Addresses

```sh
# get all addresses
sui client addresses
# get all active addresses
sui client active-addresses
# get all coins
sui client gas
```

## Setting Up

```sh
sui move new <module_name>
```

## Deploying

```sh
# run it in root folder with the module
sui client publish --gas-budget 30000

# output

BUILDING hello_world
Successfully verified dependencies on-chain against source.
----- Certificate ----
Transaction Hash: TransactionDigest(5oKPNb9xPydcUfJrQ5dcT4TQ5nAAZKpAZJUdvvQKwdjz)
Transaction Signature: [Signature(AQ==@EVXx7KD2tswnN/TtPbH3mw43i8pFCO/gaqKYLy0dPpVtqSJIPZQJXhEB+UMzsskmONoqAxGylqJNy8wEenUbhg==@A5OvyYAut3Zpy7T3S/LZL5vdfgR0+ovq4+QOUO0fxw+c)]
Signed Authorities Bitmap: RoaringBitmap<[0, 2, 3]>
Transaction Kind : Publish
Sender: 0x15d2b782e1ab6130bb312c477439126c06ffb594
Gas Payment: Object ID: 0x07e8ca322f770dcb0b3c9a3f3809d01be23798d5, version: 0xa1bd, digest: o#iPp4K/EzVurhyAaRPM69edts7LjBsJsIU7+7Ttqj9mc=
Gas Owner: 0x15d2b782e1ab6130bb312c477439126c06ffb594
Gas Price: 1
Gas Budget: 30000
----- Transaction Effects ----
Status : Success
Created Objects:
  - ID: 0xca451c8640c301b18da42f86109ec48c243d9917 , Owner: Immutable
Mutated Objects:
  - ID: 0x07e8ca322f770dcb0b3c9a3f3809d01be23798d5 , Owner: Account Address ( 0x15d2b782e1ab6130bb312c477439126c06ffb594 )
```

The package is created one can also export the key as OS ENV variable

```sh
export PACKAGE_ID=<package object ID from previous output>

## PACKAGE ID eg:
##   - ID: 0xca451c8640c301b18da42f86109ec48c243d9917 , Owner: Immutable
```

Interacting with contract

```sh
sui client call --function mint --module hello_world --package 0xca451c8640c301b18da42f86109ec48c243d9917 --gas-budget 30000

# OUTPUT

----- Certificate ----
Transaction Hash: TransactionDigest(4G9nRghVHE8BHf4DCwfPhcRpVZG1S3hjfdTSFP8CKdXj)
Transaction Signature: [Signature(AQ==@m7VpM4PNWqFimLIcebja87+vdxf2zt/O4q6fKcLlaa1AwMbB1hxYPEPNmBWsy/2Daxdfz3/1Q4ppm0kMSG631A==@A5OvyYAut3Zpy7T3S/LZL5vdfgR0+ovq4+QOUO0fxw+c)]
Signed Authorities Bitmap: RoaringBitmap<[0, 1, 2]>
Transaction Kind : Call
Package ID : 0xca451c8640c301b18da42f86109ec48c243d9917
Module : hello_world
Function : mint
Arguments : []
Type Arguments : []
Sender: 0x15d2b782e1ab6130bb312c477439126c06ffb594
Gas Payment: Object ID: 0x07e8ca322f770dcb0b3c9a3f3809d01be23798d5, version: 0xa1be, digest: o#1jBYv+naq2rN814IHZ8Y2XIra5and2NRRAIf/x/xXVk=
Gas Owner: 0x15d2b782e1ab6130bb312c477439126c06ffb594
Gas Price: 1
Gas Budget: 30000
----- Transaction Effects ----
Status : Success
Created Objects:
  - ID: 0xc31d4594ebbbd6404f4ac7cf3d61a5061c9f201c , Owner: Account Address ( 0x15d2b782e1ab6130bb312c477439126c06ffb594 )
Mutated Objects:
  - ID: 0x07e8ca322f770dcb0b3c9a3f3809d01be23798d5 , Owner: Account Address ( 0x15d2b782e1ab6130bb312c477439126c06ffb594 )
```

This transaction can also be viewed in SUI explorer

```sh
https://explorer.sui.io/object/0xc31d4594ebbbd6404f4ac7cf3d61a5061c9f201c
```
