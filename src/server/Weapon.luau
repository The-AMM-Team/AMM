--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Hitboxs = require(script.Parent.Hitboxs)
local Roles = require(script.Parent.Roles)
local Items = require(script.Parent.Items)
local Round = require(script.Parent.Round)
local Database = require(script.Parent.Database)
local Effects = require(script.Parent.Effects)
local Sound = require(ReplicatedStorage.Shared.Sound)
local Character = require(ReplicatedStorage.Shared.Character)

--<< Remotes
local ServerRemotes = require(ReplicatedStorage.Shared.Remotes.ServerRemotes)
local equip = ServerRemotes.Equip
local unequip = ServerRemotes.Unequip
local attack = ServerRemotes.Attack

--<< Private Functions
local function checkDistance(p1: Vector3, p2: Vector3): number
	return (p1 - p2).Magnitude
end

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
	
	unequip.SetCallback(function(player: Player)
		if Roles:getMurderer() == player then
			Items:mountItemToPlayer(player, "flameDragon", "LowerTorso", "RootRigAttachment", true)
	        Items:unmountItemFromPlayer(player, "RightHand", "flameDragon")
	    elseif Roles:getSheriff() == player then
			Items:mountItemToPlayer(player, "lilFlame", "LowerTorso", "RootRigAttachment", true)
	        Items:unmountItemFromPlayer(player, "RightHand", "lilFlame")
	    end
	end)

	equip.SetCallback(function(player)
	    if Roles:getMurderer() == player then
			Items:unmountItemFromPlayer(player, "LowerTorso", "flameDragon")
	        Items:mountItemToPlayer(player, "flameDragon", "RightHand", "RightGripAttachment")
	    elseif Roles:getSheriff() == player then
			Items:unmountItemFromPlayer(player, "LowerTorso", "lilFlame")
	        Items:mountItemToPlayer(player, "lilFlame", "RightHand", "RightGripAttachment")
	    end
	end)

	attack.SetCallback(function(player: Player, Data: { characterCFrame: CFrame, mousePosition: Vector3 })
		local character: Model? = player.Character
		if character and character.PrimaryPart then
			if checkDistance(Data.characterCFrame.Position, character.PrimaryPart.Position) < 3 then
				local role = Roles:getPlayerRole(player)
				if role == "sheriff" then
					self:attackWithGun(player, Data.characterCFrame, Data.mousePosition)
				elseif role == "murderer" then
					self:attackWithKnife(player, Data.characterCFrame)
				else
					--local _ = self:attackWithGun(player, Data.characterCFrame, Data.mousePosition)
				end
			end
		end
	end)
end

function module:attackWithKnife(killer: Player, characterCFrame: CFrame)
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Include
	overlapParams.FilterDescendantsInstances = Hitboxs:getAllHitboxs(function(player: Player, hitbox: Part)
		return if player == killer then false else true
	end)

	Sound:playSoundFromServerToClient("KnifeSwing", Round:getPlayersInRound(), "SFX", 0.25, characterCFrame.Position)

	local foundBaseParts = workspace:GetPartBoundsInBox(
		characterCFrame + characterCFrame.LookVector * 4,
		Vector3.new(4, 4, 4),
		overlapParams
	)
	if #foundBaseParts > 0 then
		for _, part: BasePart in foundBaseParts do
			local player = Hitboxs:isBasePartAHitbox(part)
			if player then
				self:killPlayers(killer, { player })

				local character = player.Character
				if character then
					Sound:playSoundFromServerToClient("FireKillEffect", Round:getPlayersInRound(), "SFX", 0.25, character.PrimaryPart.Position)
				end
				return
			end
		end
	end
end

function module:attackWithGun(killer: Player, characterCFrame: CFrame, hit: Vector3)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = Hitboxs:getAllHitboxs(function(player: Player, hitbox: Part)
		return if player == killer then false else true
	end)

	Sound:playSoundFromServerToClient("FlameGunShot", Round:getPlayersInRound(), "SFX", 0.5, characterCFrame.Position)
	Effects:gunTrail(characterCFrame.Position, hit, {
		destoryDelay = 1,
	})

	local result =
		workspace:Raycast(characterCFrame.Position, (hit - characterCFrame.Position).Unit * 300, raycastParams)
	if result then
		local player: Player? = Hitboxs:isBasePartAHitbox(result.Instance)
		if player then
			local character = player.Character
			if character then
				Sound:playSoundFromServerToClient("FireKillEffect", Round:getPlayersInRound(), "SFX", 0.25, character.PrimaryPart.Position)
			end
			self:killPlayers(killer, { player })
		end
	end
end

function module:killPlayers(killer: Player, playersToKill: { Player })
	for _, player: Player in playersToKill do
		local humanoid: Humanoid? = Character:getPlayersHumanoid(player)
		if humanoid then
			humanoid:TakeDamage(100)
		end
	end
end

return module
