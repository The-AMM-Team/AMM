--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Database = require(script.Parent.Database)
local Round = require(script.Parent.Round)
local Roles = require(script.Parent.Roles)
local Character = require(ReplicatedStorage.Shared.Character)
local Knifes = require(ReplicatedStorage.Shared.Info.Knifes)
local Guns = require(ReplicatedStorage.Shared.Info.Guns)

--<< Remotes
local serverNet = require(script.Parent.serverNet)

--<< Packages
local Vide = require(ReplicatedStorage.Shared.Packages.vide)
local create = Vide.create

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

--<< Private Variables
local playersCurrentlyEquip = {}
local currentPlayersMountedModelsInHand = {}
local currentPlayersMountedModelsOnHip = {}

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()

	Database.onDataLoaded:Connect(function(player: Player, data: Types.playerData)  
		Character:bindCallbackToCharacter(player, function(_: Model?)
			if data then
				self:mountGunOnHip(player, data.currentGun.name)
				self:mountKnifeOnHip(player, data.currentKnife.name)
			end
		end)
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		playersCurrentlyEquip[player] = nil
		currentPlayersMountedModelsInHand[player] = nil
	end)

	Round.onIntermissionStart:Connect(function()
		for _, player: Player in Players:GetPlayers() do
			if currentPlayersMountedModelsInHand[player] then
				currentPlayersMountedModelsInHand[player]:Destroy()

				if currentPlayersMountedModelsOnHip[player].knife then
					self:mountGunOnHip(player, Database:getPlayerData(player).currentGun.name)
				elseif currentPlayersMountedModelsOnHip[player].gun then
					self:mountKnifeOnHip(player, Database:getPlayerData(player).currentKnife.name)
				end
			end
			playersCurrentlyEquip[player] = false
		end
	end)

	--// So basically I am lost myself but this mounts the knife/Gun in hand and unmounts it from hip
	serverNet.Equip.SetCallback(function(player: Player)
		if not playersCurrentlyEquip[player] then
			if Roles:getMurderer() == player then
				self:mountKnifeOnHand(player, Database:getPlayerData(player).currentKnife.name)
				self:unmountKnifeOnHip(player)
				playersCurrentlyEquip[player] = true
			elseif Roles:getSheriff() == player then
				self:mountGunOnHand(player, Database:getPlayerData(player).currentGun.name)
				self:unmountGunOnHip(player)
				playersCurrentlyEquip[player] = true
			end
		end
	end)

	--// So basically I am lost myself but this mounts the knife/Gun in hand and unmounts it from hip
	serverNet.Unequip.SetCallback(function(player: Player)
		if playersCurrentlyEquip[player] then
			if Roles:getMurderer() == player then
				self:mountKnifeOnHip(player, Database:getPlayerData(player).currentKnife.name)
				currentPlayersMountedModelsInHand[player]:Destroy()
				playersCurrentlyEquip[player] = false
			elseif Roles:getSheriff() == player then
				self:mountGunOnHip(player, Database:getPlayerData(player).currentGun.name)
				currentPlayersMountedModelsInHand[player]:Destroy()
				playersCurrentlyEquip[player] = false
			end
		end
	end)
end

--TODO redo everything below this, super unclean dude I hate looking at this crap bro

function module:mountKnifeOnHand(player: Player, knifeName: string?): ()
	local knifeInfo: Knifes.knife? = Knifes[knifeName]
	if not knifeInfo then
		warn(`The knife with the name: {knifeName} could not be found in knifes!`)
		return
	end

	local character: Model? = player.Character or player.CharacterAdded:Wait()
	local RightHand: BasePart? = Character:getBodyPartFromCharacter(player, "RightHand")

	if RightHand and character then
		local RightGripAttachment: Attachment? = RightHand:FindFirstChild("RightGripAttachment") :: Attachment?
		if not RightGripAttachment then
			return
		end

		local model = create(knifeInfo.model)({
			Parent = character,
		})

		create("Weld")({
			Parent = model,
			C0 = model:FindFirstChild("RightGripAttachment").CFrame,
			C1 = RightGripAttachment.CFrame,
			Part0 = model,
			Part1 = RightHand,
		})

		currentPlayersMountedModelsInHand[player] = model
	end
end

function module:mountGunOnHand(player: Player, gunName: string?): ()
	local gunInfo: Guns.gun? = Guns[gunName]
	if not gunInfo then
		warn(`The gun with the name: {gunName} could not be found in gun!`)
		return
	end

	local character: Model? = player.Character or player.CharacterAdded:Wait()
	local RightHand: BasePart? = Character:getBodyPartFromCharacter(player, "RightHand")

	if RightHand and character then
		local RightGripAttachment: Attachment? = RightHand:FindFirstChild("RightGripAttachment") :: Attachment?
		if not RightGripAttachment then
			return
		end

		local model = create(gunInfo.model)({
			Parent = character,
		})

		create("Weld")({
			Parent = model,
			C0 = model:FindFirstChild("RightGripAttachment").CFrame,
			C1 = RightGripAttachment.CFrame,
			Part0 = model,
			Part1 = RightHand,
		})

		currentPlayersMountedModelsInHand[player] = model
	end
end

function module:mountKnifeOnHip(player: Player, knifeName: string?): ()
	local knifeInfo: Knifes.knife? = Knifes[knifeName]
	if not knifeInfo then
		warn(`The knife with the name: {knifeName} could not be found in knifes!`)
		return
	end

	local character: Model? = player.Character or player.CharacterAdded:Wait()
	local LowerTorso: BasePart? = Character:getBodyPartFromCharacter(player, "LowerTorso")

	if LowerTorso and character then
		local rootRigAttachment: Attachment? = LowerTorso:FindFirstChild("RootRigAttachment") :: Attachment?
		if not rootRigAttachment then
			return
		end

		local model = create(knifeInfo.model)({
			Parent = character,
		})

		create("Weld")({
			Parent = model,
			C0 = model:FindFirstChild("RootRigAttachment").CFrame + knifeInfo.offset,
			C1 = rootRigAttachment.CFrame,
			Part0 = model,
			Part1 = LowerTorso,
		})

		if not currentPlayersMountedModelsOnHip[player] then
			currentPlayersMountedModelsOnHip[player] = {}
		end

		currentPlayersMountedModelsOnHip[player].knife = model
	end
end

function module:mountGunOnHip(player: Player, gunName: string?): ()
	local gunsInfo: Guns.gun? = Guns[gunName]
	if not gunsInfo then
		warn(`The gun with the name: {gunName} could not be found in guns!`)
		return
	end

	local character: Model? = player.Character or player.CharacterAdded:Wait()
	local LowerTorso: BasePart? = Character:getBodyPartFromCharacter(player, "LowerTorso")

	if LowerTorso and character then
		local rootRigAttachment: Attachment? = LowerTorso:FindFirstChild("RootRigAttachment") :: Attachment?
		if not rootRigAttachment then
			return
		end

		local model = create(gunsInfo.model)({
			Parent = character,
		})

		create("Weld")({
			Parent = model,
			C0 = model:FindFirstChild("RootRigAttachment").CFrame + gunsInfo.offset,
			C1 = rootRigAttachment.CFrame,
			Part0 = model,
			Part1 = LowerTorso,
		})

		if not currentPlayersMountedModelsOnHip[player] then
			currentPlayersMountedModelsOnHip[player] = {}
		end

		currentPlayersMountedModelsOnHip[player].gun = model
	end
end

function module:unmountKnifeOnHip(player: Player): ()
	if currentPlayersMountedModelsOnHip[player] then
		currentPlayersMountedModelsOnHip[player].knife:Destroy()
	end
end

function module:unmountGunOnHip(player: Player): ()
	if currentPlayersMountedModelsOnHip[player] then
		currentPlayersMountedModelsOnHip[player].gun:Destroy()
	end
end

return module
