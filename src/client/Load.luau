--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Sound = require(ReplicatedStorage.Shared.Sound)
local Animation = require(script.Parent.Animation)
local Settings = require(script.Parent.Settings)
local Coin = require(script.Parent.Coins)
local loading = require(ReplicatedStorage.Shared.UI.loading)
local menu = require(ReplicatedStorage.Shared.UI.menu)

local module = {}

function module:Start(debug: true?)
	local loadingThings: { [string]: (debug: true?) -> () } = {
		["Loading Sound"] = Sound.loadAllSounds,
		["Loading Animations"] = Animation.loadAllAnimation,
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
		end,
	}

	loading(loadingThings)

	menu()
end

return module
