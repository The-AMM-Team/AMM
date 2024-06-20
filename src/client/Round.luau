--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Remotes
local clientNet = require(script.Parent.clientNet)

--<< Modules
local role = require(ReplicatedStorage.Shared.UI.role)
local Coins = require(script.Parent.Coins)

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)

local module = {}

function module:Start()
	clientNet.Round.SetCallback(function(roundInfo)
		if roundInfo.started then
			role(fusion.scoped(fusion), {
				role = roundInfo.role,
			})
		else
			Coins:clearAllCoins()
		end
	end)
end

return module
