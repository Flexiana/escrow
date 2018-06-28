# Escrow smart contract

Trustless business will need some time to have working governance & problem resolution. We develop apps in blockchain field (from protocol level through smart contracts, ICOs to layer 2 apps). For that we felt we need some more protection in extremely unregulated environment. This is why we created Escrow smart contract.

We're sorry we mention Flexiana as one of the parties. In one of next versions we will replace Flexiana with Delivery.

## How to deploy

### Deployment to mainnet

Probably easiest way to compile and deploy smartcontract can be found here: https://ethereum.stackexchange.com/questions/33536/how-to-compile-and-deploy-a-smart-contract-without-running-a-full-node

### Setting addresses

After creating a contract, owner must call `setAddressesOnce(judge, delivery, customer)` and setup addresses.
This method can be called just once. Every other call ends with exeption.

## How to use as a judge

Please, backup your private key. Only flexiana+customer cooperating and holding keys can recover funds on this address.

Judge can call exactly 2 methods:

1. `transferToCustomer`
2. `transferToFlexiana`

## How to use as a delivery

Please, backup your private key on secure location. Loosing private key means that only judge can recover funds by transfering them back to the customer.

### Changing status (return to sender, transfer to you)

Flexiana can setup 3 statuses:

1. `changeFlexianaStatusToDoNothing` - calling this method, Flexiana signals that funds should stay in the escrow
2. `changeFlexianaStatusToShouldTransferToCustomer` - calling this method says that Flexiana wants to return escrow back to customer
3. `changeFlexianaStatusToShouldTransferToFlexiana` - calling this method says that Flexiana wants to withdraw funds

### Withdrawal

For withdrawals, Flexiana can call 2 methods:

1. `transferToFlexiana` - if flexiana has status ShouldTransferToCustomer, anyone can call this method.
2. `withdraw` - if customer and you have status ShouldTransferToFlexiana, method automatically recognizes you are eligible recipient and will send funds to your address.

## How to use as a customer

Please keep private key backed up in secure location. If you'll loose private key, only judge can recover funds by calling transferToFlexiana by transfering funds to Flexiana.

### Changing status (return to sender, transfer to you)

Customer can setup 3 statuses:

1. `changeCustomerStatusToDoNothing` -  by calling this method, customer states, she doesn't want to do anything with funds in escrow
2. `changeCustomerStatusToShouldTransferToCustomer` - by calling this method, customer states that funds should return back to customer
3. `changeCustomerStatusToShouldTransferToFlexiana` - by calling this method, customer states that funds should be transferred to Flexiana

### Withdrawal

For withdrawals, customer can call 2 methods:

1. `transferToCustomer` - if Flexiana has status ShouldTransferToCustomer, anyone can call this method.
2. `withdraw` - if Flexiana and you have status ShouldTransferToCustomer, method automatically recognizes you are eligible recipient and will send funds to your address.

### Deposit

SmartContract has 2 deposit methods.

1. `deposit` - accepts any amount of Ethereum (note, only ETH can be withdrawn, any other token sent to the address will be lost!).
2. `customerDeposit` - slightly more secure. It allows transaction only from customer address. Important note: do not send any tokens to this address. This smart contract allows only Ethereum withdrawal.

Please note you can deposit multiple times.
Currently, withdrawal is possible only all at once. Partial withdrawals aren't implemented yet.

## How to check balance of ETH

There are multiple ways to check balance of given address.
Easiest way on mainnet are:

- https://www.etherchain.org
- https://etherscan.io 

  
## TODO

- Write Unit Tests #javascript
- Remove dependency on OpenZeppelin's ownable #easy #solidity
- Remove mentions of Flexiana in contract API #easy #solidity
- Partial withdrawals & authorizing partial withdrawal #solidity
- Some UI to create, inspect & manage escrows #maybe #javascript #golang 

## Support us

- Please, don't remove LICENSE file & when you will use it, let world know you are using Flexiana library
- If you need to write any smart contract, contact us on jiri@flexiana.com
- Feel free to donate Litecoin to address LWZXy7zp9Lj6aFYJi8XdDN96rEptL6c1te or ETH to address 0xa92f637e930395e81D3b6e78ACbAEA8DE735CB46 or BTC to address 1P4m6neNV1pm8WwGDex64tKn4zezg2xLG3
