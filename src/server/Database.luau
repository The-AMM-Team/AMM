--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Datakeep = require(ReplicatedStorage.Shared.ServerPackages.datakeep)
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)

--<< Network
local serverNet = require(script.Parent.serverNet)
local Coins = serverNet.Coins
local loadSettings = serverNet.LoadSettings
local setSetting = serverNet.SetSetting

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

--<< Private Variables
local template: Types.playerData = {

	coins = 0,

	settings = {
		music = false,
		sound = true,
	},

	currentKnife = {
		name = "flameDragon",
	},
	currentGun = {
		name = "lilFlame",
	},

	roles = { "contributer", "tester", "developer" },
	joinDate = os.time(),
}

local _, keepStore = Datakeep.GetStore("MAIN", template)
	:catch(function(err: string)
		for _, player in Players:GetPlayers() do
			player:Kick("Server Error")
		end
	end)
	:await()

keepStore.Wrapper = {

	addCoins = function(keep, amount: number)
		keep.Data.coins += 1
	end,

	removeCoins = function(keep, amount: number)
		keep.Data.coins -= amount
	end,
}

local keeps = {}

--<< Public Variables
local module = {
	onDataLoaded = Signal.new(),
}

--<< Public Functions
function module:Start()
	for _, player: Player in Players:GetPlayers() do
		self:playerAdded(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self:playerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		local keep = keeps[player]

		if not keep then
			return
		end

		keeps[player] = nil
	end)

	setSetting.SetCallback(function(player: Player, setting: { data: boolean, name: string })
		local data: Types.playerData? = self:getKeepData(player)
		if data then
			data.settings[setting.name] = setting.data
		end
	end)
end

function module:playerAdded(player: Player)
	warn(keepStore)
	keepStore
		:LoadKeep(player.UserId)
		:andThen(function(keep)
			keep:Reconcile()
			keep:AddUserId(player.UserId)

			keep.Releasing:Connect(function(state)
				state
					:andThen(function()
						player:Kick("Session Saved!")
					end)
					:catch(warn)
			end)

			if not player:IsDescendantOf(Players) then
				keep:Release()
				return
			end

			keeps[player] = keep

			Coins.Fire(player, keep.Data.coins)
			loadSettings.Fire(player, keep.Data.settings)
		end)
		:catch(warn)
end

function module:getKeep(player)
	return keeps[player]
end

function module:getKeepData(player: Player): Types.playerData?
	return keeps[player].Data
end

return module

