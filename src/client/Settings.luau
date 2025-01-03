--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local peek = fusion.peek

--<< Modules
local Input = require(script.Parent.Input)
local Coins = require(script.Parent.Coins)
local Sound = require(ReplicatedStorage.Shared.Sound)
local globalUIState = require(ReplicatedStorage.Shared.Info.GlobalUIState)
local settingsUI = require(ReplicatedStorage.Shared.UI.settings)

--<< Remotes
local ClientRemotes = require(ReplicatedStorage.Shared.Remotes.ClientRemotes)
local loadSettingsRemote = ClientRemotes.LoadSettings
local setSettingRemote = ClientRemotes.SetSetting

--<< Private Variables
local loadedSettings = fusion.Value({}, false)

local module = {}

function module:Start()
	loadSettingsRemote.SetCallback(function(settings)

		Sound:createSoundGroup("music")
		Sound:toggleGroup("music", settings.music)

		Sound:createSoundGroup("SFX")
		Sound:toggleGroup("SFX", settings.sound)

		Sound:playMusic()

		settingsUI({
			{
				name = "Music",
				desc = "toggle background music",
				callback = function(on: boolean)
					self:toggleMusic(on)
					Sound:playSoundOnClient("UI Click 1", {
						async = true,
						group = "SFX",
						volume = 1,
					})
				end,
				defaultValue = settings["music"],
			},
			{
				name = "SFX",
				desc = "toggle sound effects",
				callback = function(on: boolean)
					self:toggleSoundEffects(on)
					Sound:playSoundOnClient("UI Click 1", {
						async = true,
						group = "SFX",
						volume = 1,
					})
				end,
				defaultValue = settings["sound"],
			},
			{
				name = "Potato Mode",
				desc = "reduces lag",
				callback = function(on: boolean)
					self:togglePotatoMode(on)
					Sound:playSoundOnClient("UI Click 1", {
						async = true,
						group = "SFX",
						volume = 1,
					})
				end,
				defaultValue = settings["potatoMode"],
			},
		})

		loadedSettings:set(true)
	end)

	Input:bindToInput(Enum.KeyCode.T, function()
		if peek(globalUIState.currentOpenedMenu) == "settings" then
			globalUIState.currentOpenedMenu:set(nil)
		else
			globalUIState.currentOpenedMenu:set("settings")
		end
	end)
end

function module:togglePotatoMode(on: boolean)
	Coins:setPotatoMode(on)
	setSettingRemote.Fire({
		name = "potatoMode",
		data = on
	})
end

function module:toggleMusic(on: boolean)
	Sound:toggleGroup("music", on)
	setSettingRemote.Fire({
		name = "music",
		data = on,
	})
end

function module:toggleSoundEffects(on: boolean)
	Sound:toggleGroup("SFX", on)
	setSettingRemote.Fire({
		name = "sound",
		data = on,
	})
end

function module:settingsLoaded(): boolean
	return peek(loadedSettings)
end

return module
