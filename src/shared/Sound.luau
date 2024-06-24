--<< Services
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local clientNet = if RunService:IsClient() then 
	require(ReplicatedStorage.Shared.Remotes.ClientRemotes)
else
	require(ReplicatedStorage.Shared.Remotes.ServerRemotes)
local Sound = clientNet.Sound

--<< Modules
local Debug = require(script.Parent.Debug)

--<< Packages
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = fusion.scoped

--<< Types
type soundSettings = {
	group: string,
	volume: number?,
	playbackSpeed: number?,
	async: boolean?,
	onInterupt: () -> ()?,
	onComplete: () -> ()?,
	parent: Instance?,
	playAtPosition: Vector3?,
}

type soundGroupInfo = {
	scope: fusion.Scope<typeof(fusion)>,
	folder: Folder,
	endAllSound: Signal.Signal<nil>,
	enable: boolean,
}

--<< Private Variables
local soundGroups: { [string]: soundGroupInfo } = {}
local sounds: { [string]: number } = {

	--<< Kill Effects
	["cheeseBurger"] = 16647570,

	--<< UI
	["UI Click 1"] = 6895079853,

	["click 1"] = 876939830,
	["kick boom 1"] = 1837831489,

	--<< Music
	["Clair De Lune"] = 1838457617,
	["Gymnopedie"] = 9045766377,
	["Piano Bar jazz"] = 1841979451,
	["Nocturne Opus 9 C"] = 1848028342,
	["Solo Piano - Fur Elise - Remastered"] = 9046645246,

	--<< Collecting
	["Coin Collect"] = 1169755927,

	--<< Weapon
	["KnifeSwing"] = 3939935996,
	
	["FlameGunShot"] = 3634981288,
	["FireKillEffect"] = 8741569477,

	--<< Misc
	["yay"] = 8304443672,
}

--<< Private Functions
local function findSoundIdFromString(name: string): number
	return sounds[name] or error(`Could not find sound: {name} in sounds`, 1)
end

local function createSound(
	scope: fusion.Scope<typeof(fusion)>,
	id: number,
	parent: Instance,
	soundSettings: soundSettings
): Sound
	return scope:New("Sound")({
		SoundId = `rbxassetid://{id}`,
		Volume = soundSettings.volume or 0.5,
		PlaybackSpeed = soundSettings.playbackSpeed or 1,
		Parent = parent,
	}) :: Sound
end

local function createSoundGroupFolder(group: string): Folder
	local folder = Instance.new("Folder", SoundService)
	folder.Name = group
	return folder
end

local function playSound(sound: Sound, onfinish: () -> ()?)
	sound:Play()
	repeat
		task.wait()
	until not sound.Playing or not sound.Parent
	if onfinish then
		onfinish()
	end
end

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
	assert("can't call this on the client", 2)

	Sound.SetCallback(function(data: { group: string, id: string, volume: number, playAt: Vector3? })  
		self:playSoundOnClient(data.id, {
			group = data.group,
			Volume = data.volume,
			playAtPosition = data.playAt,
		})
	end)
end

function module:playMusic()
	assert(RunService:IsClient(), "you must call this on the client")

	local music = table.freeze({
		"Clair De Lune",
		"Gymnopedie",
		"Piano Bar jazz",
		"Nocturne Opus 9 C",
		"Solo Piano - Fur Elise - Remastered",
	})

	local function playMusic(lastMusic: string?): ()
		local clonedMusicTable = table.clone(music)
		if lastMusic then
			table.remove(clonedMusicTable, table.find(clonedMusicTable, lastMusic))
		end

		local randomMusic = clonedMusicTable[math.random(1, #clonedMusicTable)]

		self:playSoundOnClient(randomMusic, {
			group = "music",
			async = false,
			volume = 1,
		})

		task.wait(3)

		playMusic(randomMusic)
	end

	task.spawn(playMusic)
end

function module.loadAllSounds(showDebugInfo: boolean?): ()
	local folder = Instance.new("Folder", SoundService)
	folder.Name = "Loading Sounds"

	local allSoundInstances: { Sound } = {}
	for name: string, id: number in sounds do
		local sound = Instance.new("Sound", folder)
		sound.SoundId = `rbxassetid://{id}`
		table.insert(allSoundInstances, sound)

		if showDebugInfo then
			print(`Started Loading: {name}`)
		end
	end

	print(
		`Sounds took: {Debug:timeFunctionCall(ContentProvider.PreloadAsync, ContentProvider, allSoundInstances)}s to load!`
	)
end

function module:playSoundFromServerToClient(id: string, to: {Player}, group: string, volume: number, playAt: Vector3?): ()
	assert(sounds[id], `the sound "{id}" was not found...`)
	warn("Fire")
	Sound.FireList(to, {
		id = id,
		group = group,
		volume = volume,
		playAt = playAt,
	})
end

function module:playSoundOnClient(id: string, soundSettings: soundSettings): ()

	local groupInfo: soundGroupInfo = if soundGroups[soundSettings.group]
		then soundGroups[soundSettings.group]
		else self:createSoundGroup(soundSettings.group)
	if not groupInfo.enable then
		return
	end

	local soundScope = groupInfo.scope:innerScope()

	local sound: Sound =
		createSound(soundScope, findSoundIdFromString(id), if soundSettings.playAtPosition then groupInfo.scope:New "Part" {
			Parent = workspace,
			Position = soundSettings.playAtPosition,
			Size = Vector3.new(1, 1, 1),
			CanCollide = false,
			Transparency = 1,
			Anchored = true,
		} elseif soundSettings.parent then soundSettings.parent else groupInfo.folder, soundSettings)
	if not sound.IsLoaded then
		sound.Loaded:Wait()
	end

	local eventConnection = groupInfo.endAllSound:Connect(function()
		sound:Destroy()
		if soundSettings.onInterupt then
			soundSettings.onInterupt()
		end
	end)

	table.insert(soundScope, function()
		eventConnection:Disconnect()
	end)

	if soundSettings.async then
		task.spawn(playSound, sound, function()
			if soundSettings.onComplete then
				soundSettings.onComplete()
			end
			fusion.doCleanup(soundScope)
		end)
	else
		playSound(sound)
		fusion.doCleanup(soundScope)
	end
end

function module:createSoundGroup(name: string): false | soundGroupInfo
	if soundGroups[name] then
		return false
	end

	local groupScope: fusion.Scope<typeof(fusion)> = scoped(fusion)
	soundGroups[name] = {
		scope = groupScope,
		folder = createSoundGroupFolder(name),
		endAllSound = Signal.new(),
		enable = true,
	}

	return soundGroups[name]
end

function module:getSoundGroupInfo(name: string): soundGroupInfo?
	return soundGroups[name]
end

function module:toggleGroup(group: string, on: boolean)
	local groupInfo = soundGroups[group]
	if not groupInfo then
		return
	end

	if on then
		groupInfo.enable = true
	else
		groupInfo.enable = false
		groupInfo.endAllSound:Fire()
	end
end

return module
