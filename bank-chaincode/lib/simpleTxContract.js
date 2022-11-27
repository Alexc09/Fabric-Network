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
                Name: "BankA",
                Balance: 100,
                PreviousTx: "0x00"
            },
            {
                Name: "BankB",
                Balance: 50,
                PreviousTx: "0x00"
            },
            {
                Name: "Printer",
                Balance: 10000,
                PreviousTx: "0x00"
            },
        ]
        for (let asset of assets) {
            await ctx.stub.putState(asset.Name, Buffer.from(JSON.stringify(asset)))
        }
    }

    async getBalance(ctx, name) {
        const asset = await ctx.stub.getState(name)
        if (!asset || asset.length == 0) {
            throw new Error(`Balance for ${name} does not exist`)
        }
        return asset.toString()
    }
    

    async transfer(ctx, sender, receiver, amount) {
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

    async exists(ctx, name) {
        const asset = await this.getBalance(name)
        return asset && asset.length > 0
    }

    async getAllBalances(ctx) {
        const allAssets = []
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