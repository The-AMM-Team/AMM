--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Remotes
local ClientRemotes = require(ReplicatedStorage.Shared.Remotes.ClientRemotes)
local Round = ClientRemotes.Round

--<< Modules
local roleUI = require(ReplicatedStorage.Shared.UI.role)
local Coins = require(script.Parent.Coins)

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)

--<< Private Varaibles
local role = fusion.Value({}, nil)
local round = fusion.Value({}, false)

local module = {}

function module:Start()
	Round.SetCallback(function(roundInfo)
		if roundInfo.started then
			role:set(roundInfo.role)
			roleUI(fusion.scoped(fusion), {
				role = fusion.peek(role),
			})
			task.wait(3)
			round:set(true)
		else
			round:set(false)
			Coins:clearAllCoins()
		end
	end)
end

function module:getRole(): string?
	return fusion.peek(role)
end

function module:getRoleState(): fusion.UsedAs<string?>
	return role
end

function module:getRoundState(): fusion.UsedAs<boolean>
	return round
end

return module
