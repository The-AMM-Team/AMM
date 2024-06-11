--TODOS
--1. add anti cheat

--<< Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local peek = fusion.peek
local scoped = fusion.scoped

--<< Private Variables
local playerHitboxScope = scoped(fusion)
local visible = fusion.Value({}, false)
local playerConnections: { [Player]: fusion.Scope<typeof(fusion)> } = {}
local playerHitboxs: { [Player]: Part } = {}

--<< Private Functions
local function createHitbox(scope: fusion.Scope<typeof(fusion)>, position: fusion.UsedAs<Vector3>): Part
	return scope:New("Part")({
		Parent = workspace,
		Name = "HITBOX",
		Color = Color3.fromRGB(255, 0, 0),
		Anchored = true,
		CanCollide = false,
		Size = Vector3.new(3.5, 6, 3.5),
		Position = position,
		Transparency = playerHitboxScope:Computed(function(use, scope)
			return if use(visible) then 0.5 else 1
		end),
	}) :: Part
end

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
	for _, player: Player in Players:GetPlayers() do
		self:playerAdded(player)
	end

	Players.PlayerAdded:Connect(function(player: Player)
		self:playerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		fusion.doCleanup(playerConnections[player])
	end)
end

function module:playerAdded(player: Player)

	local playerScope = playerHitboxScope:innerScope()
	playerConnections[player] = playerScope

	local character = player.Character
	if character then
		for _, instance: Instance in character:GetChildren() do
			if instance:IsA("BasePart") then
				instance.CollisionGroup = "Player"
			end
		end
	end

	table.insert(
		playerScope,
		player.CharacterAdded:Connect(function(newCharacter)
			for _, instance: Instance in newCharacter:GetChildren() do
				if instance:IsA("BasePart") then
					instance.CollisionGroup = "Player"
				end
			end
		end)
	)

	local currentCharactersPosition = playerScope:Value(Vector3.new(0, 0, 0))
	table.insert(
		playerScope,
		RunService.Heartbeat:Connect(function()
			local character = player.Character
			if character and character.PrimaryPart then
				currentCharactersPosition:set(character.PrimaryPart.Position)
			end
		end)
	)

	playerHitboxs[player] = createHitbox(playerScope, currentCharactersPosition)
end

function module:toggleVisibleHitboxs(toggle: boolean): ()
	visible:set(toggle)
end

function module:isHitboxShown(): boolean
	return peek(visible)
end

function module:getAllHitboxs(filter: (player: Player, hitbox: Part) -> ()): { Part }
	local out: { Part } = {}
	for player: Player, hitbox: Part in playerHitboxs do
		if filter(player, hitbox) then
			table.insert(out, hitbox)
		end
	end
	return out
end

function module:isBasePartAHitbox(part: BasePart): Player?
	for player: Player, hitbox: Part in playerHitboxs do
		if hitbox == part then
			return player
		end
	end
	return nil
end

function module:getHitbox(player: Player): Part
	return playerHitboxs[player]
end

return module
