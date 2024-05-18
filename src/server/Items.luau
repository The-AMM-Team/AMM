--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Database = require(script.Parent.Database)

local Character = require(ReplicatedStorage.Shared.Character)
local Knifes = require(ReplicatedStorage.Shared.Info.Knifes)
local Guns = require(ReplicatedStorage.Shared.Info.Guns)

--<< Remotes

--<< Packages

--<< Types

--<< Private Variables
local currentPlayersMountedModelsOnHip = {}

--<< Private Functions
local function createWeld(parent: Instance, part0: BasePart, part1: BasePart): Weld
	local weld = Instance.new("Weld")
	weld.Parent = parent
	weld.Part0 = part0
	weld.Part1 = part1
	return weld
end

--<< Public Variables
local module = {}

--<< Public Functions
function module:getPlayerKnife(player): string
	return Database:getPlayerData(player).currentKnife.name
end

function module:getPlayerGun(player): string
	return Database:getPlayerData(player).currentGun.name
end

function module:mountKnifeInHand(player: Player): BasePart?
	local character = player.Character
	local rightHand = Character:getBodyPartFromCharacter(player, "RightHand")

	if character and rightHand then
		local knife: BasePart = Knifes[self:getPlayerKnife(player)].model:Clone()
		knife.Parent = player.Character

		local weld = createWeld(character, knife, rightHand)

		local rightHandAttachment: Attachment = weld.Part0:FindFirstChild("RightGripAttachment") :: Attachment
		local knifeHandAttachment: Attachment = weld.Part1:FindFirstChild("RightGripAttachment") :: Attachment

		weld.C0 = rightHandAttachment.CFrame
		weld.C1 = knifeHandAttachment.CFrame

		return knife
	end

	return nil
end

function module:mountGunInHand(player: Player): BasePart?
	local character = player.Character
	local rightHand = Character:getBodyPartFromCharacter(player, "RightHand")
	if rightHand and character then
		local gun: BasePart = Guns[self:getPlayerGun(player)].model:Clone()
		gun.Parent = player.Character

		local weld = createWeld(character, gun, rightHand)

		local rightHandAttachment: Attachment = weld.Part0:FindFirstChild("RightGripAttachment") :: Attachment
		local knifeHandAttachment: Attachment = weld.Part1:FindFirstChild("RightGripAttachment") :: Attachment

		weld.C0 = rightHandAttachment.CFrame
		weld.C1 = knifeHandAttachment.CFrame

		return gun
	end
	return nil
end

function module:mountKnifeOnHip(player: Player): BasePart?
	local character = player.Character or player.CharacterAdded:Wait()
	local LowerTorso = Character:getBodyPartFromCharacter(player, "LowerTorso")
	if LowerTorso and character then
		local knife: BasePart = Knifes[self:getPlayerKnife(player)].model:Clone()
		knife.Parent = player.Character

		local weld = createWeld(knife, knife, LowerTorso)

		local RootRigAttachment: Attachment = weld.Part0:FindFirstChild("RootRigAttachment") :: Attachment
		local knifeHandAttachment: Attachment = weld.Part1:FindFirstChild("RootRigAttachment") :: Attachment

		weld.C0 = RootRigAttachment.CFrame + Vector3.new(1.2, 0, 0)
		weld.C1 = knifeHandAttachment.CFrame

		if not currentPlayersMountedModelsOnHip[player] then
			currentPlayersMountedModelsOnHip[player] = {}
		end
		currentPlayersMountedModelsOnHip[player].knife = knife
	end
end

function module:mountGunOnHip(player: Player)
	local character = player.Character or player.CharacterAdded:Wait()
	local LowerTorso = Character:getBodyPartFromCharacter(player, "LowerTorso")
	if LowerTorso and character then
		local gun: BasePart = Guns[self:getPlayerGun(player)].model:Clone()
		gun.Parent = player.Character

		local weld = createWeld(gun, gun, LowerTorso)

		local RootRigAttachment: Attachment = weld.Part0:FindFirstChild("RootRigAttachment") :: Attachment
		local gunHandAttachment: Attachment = weld.Part1:FindFirstChild("RootRigAttachment") :: Attachment

		weld.C0 = RootRigAttachment.CFrame + Vector3.new(-1.2, 0, 0)
		weld.C1 = gunHandAttachment.CFrame

		if not currentPlayersMountedModelsOnHip[player] then
			currentPlayersMountedModelsOnHip[player] = {}
		end
		currentPlayersMountedModelsOnHip[player].gun = gun
	end
end

function module:unmountKnifeOnHip(player: Player)
	if currentPlayersMountedModelsOnHip[player] then
		currentPlayersMountedModelsOnHip[player].knife:Destroy()
	end
end

function module:unmountGunOnHip(player: Player)
	if currentPlayersMountedModelsOnHip[player] then
		currentPlayersMountedModelsOnHip[player].gun:Destroy()
	end
end

task.delay(1, function()
	module:mountKnifeOnHip(game:GetService("Players").VanishedIntoNothing)
	module:mountGunOnHip(game:GetService("Players").VanishedIntoNothing)
end)

return module
