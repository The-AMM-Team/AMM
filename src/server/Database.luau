--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--<< Packages
local Datakeep = require(ReplicatedStorage.Shared.ServerPackages.datakeep)
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)

--<< Network
local serverNet = require(script.Parent.serverNet)
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

local KeepStore = Datakeep.GetStore(if RunService:IsStudio() then "TEMP" else "MAIN", template):expect()

local loadedKeeps = {}
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
		local keep = self:getKeep(player)

		if keep then
			keep:Release()
		end
	end)

	setSetting.SetCallback(function(player: Player, setting: { data: boolean, name: string })
		local data: Types.playerData? = self:getPlayerData(player)
		if data then
			local currentSettingValue: boolean? = data.settings[setting.name]
			if currentSettingValue then
				currentSettingValue = setting.data
			end
		end
	end)
end

function module:playerAdded(player: Player)
	KeepStore:LoadKeep(`PLAYER_{player.UserId}`):andThen(function(keep)
		if not keep then
			player:Kick("Data Couldn't load :/")
		end

		keep.Releasing:Connect(function(state)
			state
				:andThen(function()
					print(`{player.Name} is releasing keep!`)
					player:Kick("Session Release")
				end)
				:catch(function(err)
					warn(`player failed to releasse {player.Name} keep!`, err)
				end)
		end)

		if not player:IsDescendantOf(Players) then
			keep:Release()
			return
		end

		loadedKeeps[player] = keep
		keep.Data = template

		loadSettings.Fire(player, keep.Data.settings)

		self.onDataLoaded:Fire(player, keep.Data)
	end)
end

function module:getAllPlayersKeeps(): { [Player]: any }
	return loadedKeeps
end

function module:getPlayerData(player: Player): Types.playerData?
	local keep = self:getKeep(player)
	return if keep then keep.Data else nil
end

function module:getKeep(player: Player): any?
	return loadedKeeps[player]
end

return module
