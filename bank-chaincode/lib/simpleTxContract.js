'use strict'

const { Contract } = require("fabric-contract-api")

class simpleTxContract extends Contract {
    constructor() {
        super("simpleTxContract")
        this.TxId = ""
    }

    async beforeTransaction(ctx) {
        this.TxId = ctx.stub.getTxID()
        console.log(`Logging for ${this.TxId}`)
    }

    async afterTransaction(ctx, result) {
        console.log(`Tx ${this.TxId} is done`)
    }


    async init(ctx) {
        const assets = [
            {
                Name: "Alice",
                Balance: 100,
                PreviousTx: "0x00"
            },
            {
                Name: "Bob",
                Balance: 100,
                PreviousTx: "0x00"
            },
            {
                Name: "Chad",
                Balance: 200,
                PreviousTx: "0x00"
            },
        ]

        for (const asset of assets) {
            await ctx.stub.putState(asset.Name, Buffer.from(JSON.stringify(asset)))
        }
    }

    // Adds amount to user's balance. If user does not exist, create the entry. Else update the existing entry
    async setBalance(ctx, name, amount) {
        let model = {
            Name: name,
            Balance: parseFloat(amount),
            PreviousTx: this.TxId
        }

        try {
            await ctx.stub.putState(name, Buffer.from(JSON.stringify(model)))
            
            return model
        } catch (e) {
            throw new Error(`Tx ${this.TxId} had an error: ${e}`)
        }
    }

    // Get the balance of a user
    async getBalance(ctx, name) {
        const asset = await ctx.stub.getState(name)
        if (!asset || asset.length == 0) {
            throw new Error(`Asset ${name} does not exist`)
        }
        return asset.toString()
    }
    
    // Transfers asset from one user to another
    async transfer(ctx, sender, receiver, amount) { 
        // amount is a string, so have to convert to float/int such that we can perform add/subtract operations (If not + operation will be treated as a string add, not a numerical add)
        amount = parseFloat(amount)
        if (amount <= 0) {
            throw new Error(`Invalid amount provided: ${amount}`)
        }
        let sender_assetStr = await this.getBalance(ctx, sender)
        let receiver_assetStr = await this.getBalance(ctx, receiver)

        let sender_asset = JSON.parse(sender_assetStr)
        let receiver_asset = JSON.parse(receiver_assetStr)

        if (sender_asset.Balance < amount) {
            throw new Error(`${sender.Name} has insufficient balance: ${sender_asset.Balance}`)
        }
        
        sender_asset.Balance = parseFloat(sender_asset.Balance) - amount
        receiver_asset.Balance = parseFloat(receiver_asset.Balance) + amount

        await ctx.stub.putState(sender, Buffer.from(JSON.stringify(sender_asset)))
        await ctx.stub.putState(receiver, Buffer.from(JSON.stringify(receiver_asset)))
        return {
            sender: sender_asset.Balance,
            receiver: receiver_asset.Balance
        }
    }

    // Check if an entry with name exists
    async exists(ctx, name) {
        const asset = await this.getBalance(ctx, name)
        return asset && asset.length >0
    }

    // Returns all the entries in the db
    async getAllBalances(ctx) {
        const allAssets = [];
        const iterator = await ctx.stub.getStateByRange("", "")
        let result = await iterator.next()
        while (!result.done) {
            const assetStr = Buffer.from(result.value.value.toString()).toString("utf8")
            let record
            try {
                record = JSON.parse(assetStr)
            } catch (err) {
                console.log(err)
                record = assetStr
            }
            allAssets.push(record)
            result = await iterator.next()
        }
        return JSON.stringify(allAssets)
    }
}

module.exports = simpleTxContract