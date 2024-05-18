--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Hitboxs = require(script.Parent.Hitboxs)
local Roles = require(script.Parent.Roles)
local Character = require(ReplicatedStorage.Shared.Character)

--<< Remotes
local serverNet = require(script.Parent.serverNet)

--<< Private Functions
local function checkDistance(p1: Vector3, p2: Vector3): number
	return (p1 - p2).Magnitude
end

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
	-- serverNet.Unequip.SetCallback(function(player: Player)
	--     if modelsOnPlayers[player] then
	--         modelsOnPlayers[player]:Destroy()
	--     end
	-- end)

	-- serverNet.Equip.SetCallback(function(player)
	--     if Roles:getMurderer() == player then
	--         modelsOnPlayers[player] = self:mountKnife(player)
	--     elseif Roles:getSheriff() == player then
	--         modelsOnPlayers[player] = self:mountGun(player)
	--     end
	-- end)

	serverNet.Attack.SetCallback(function(player: Player, Data: { characterCFrame: CFrame, mousePosition: Vector3 })
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

	local result =
		workspace:Raycast(characterCFrame.Position, (hit - characterCFrame.Position).Unit * 300, raycastParams)
	if result then
		local player: Player? = Hitboxs:isBasePartAHitbox(result.Instance)
		if player then
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
