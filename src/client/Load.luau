--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Sound = require(ReplicatedStorage.Shared.Sound)
local Settings = require(script.Parent.Settings)
local Coin = require(script.Parent.Coin)
local loading = require(ReplicatedStorage.Shared.UI.loading)

local module = {}

function module:Start(debug: true?)

	local loadingThings: { [string]: (debug: true?) -> () } = {
		["Loading Sound"] = Sound.loadAllSounds,
		["Loading Coins"] = function()
			Coin:Start()
			repeat
				task.wait()
			until Coin:getCoins()
			Coin:hide(false) 
		end,
		["Loading Settings"] = function()
			Settings:Start()
			repeat
				task.wait()
			until Settings:settingsLoaded()
		end
	}

	loading(loadingThings)

end

return module
