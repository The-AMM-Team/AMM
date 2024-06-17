--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local coins = require(ReplicatedStorage.Shared.UI.coins)

--<< Remotes
local clientNet = require(script.Parent.clientNet)

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = fusion.scoped
local peek = fusion.peek

--<< Types

--<< Private Variables
local coinsScope = scoped(fusion)
local coinAmount = coinsScope:Value(nil)
local hide = coinsScope:Value(true)

--<< Private Functions

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()

    clientNet.Coins.SetCallback(function(amount: number)
        coinAmount:set(amount)
    end)

    coins(coinAmount, hide)
end

function module:hide(on: boolean)
    hide:set(on)
end

function module:getCoins(): number?
    return peek(coinAmount)
end

return module