--<< Services
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")

--<< Modules
local Debug = require(script.Parent.Debug)

--<< Types
type soundSettings = {
	volume: number?,
	playbackSpeed: number?,
	async: boolean?,
}

--<< Private Variables
local sounds: { [string]: number } = {

	["cheeseBurger"] = 16647570,

	["click 1"] = 876939830,
	["kick boom 1"] = 1837831489,

	["yay"] = 8304443672,
}

--<< Private Functions
local function findSoundIdFromString(name: string): number
	return sounds[name] or error(`Could not find sound: {name} in sounds`, 1)
end

local function createSound(id: number, soundSettings: soundSettings): Sound
	local sound = Instance.new("Sound")
	sound.SoundId = `rbxassetid://{id}`
	sound.Volume = soundSettings.volume or 0.5
	sound.PlaybackSpeed = soundSettings.playbackSpeed or 1
	sound.Parent = SoundService
	return sound
end

--<< Global Variables
local module = {}

--<< Global Functions
function module:loadAllSounds()
	local allSoundInstances: { Sound } = {}
	for name: string, id: number in sounds do
		local sound = Instance.new("Sound", SoundService)
		sound.SoundId = `rbxassetid://{id}`
		table.insert(allSoundInstances, sound)
	end
	print(
		`Sounds took: {Debug:timeFunctionCall(ContentProvider.PreloadAsync, ContentProvider, allSoundInstances)} long to load!`
	)
end

function module:playLocalSound(id: string, soundSettings: soundSettings?): ()
	assert(RunService:IsClient(), "Cannot be called on server!")

	local sound = createSound(findSoundIdFromString(id), soundSettings or {})
	if soundSettings and soundSettings.async then
		task.spawn(function()
			sound:Play()
			task.wait(sound.TimeLength)
			sound:Destroy()
		end)
	else
		sound:Play()
		task.wait(sound.TimeLength)
		sound:Destroy()
	end
end

function module:playSoundOnPart(id: string, parent: BasePart, soundSettings: soundSettings?): ()
	local sound = createSound(findSoundIdFromString(id), soundSettings or {})
	if soundSettings and soundSettings.async then
		task.spawn(function()
			sound:Play()
			task.wait(sound.TimeLength)
			sound:Destroy()
		end)
	else
		sound:Play()
		task.wait(sound.TimeLength)
		sound:Destroy()
	end
end

return module
