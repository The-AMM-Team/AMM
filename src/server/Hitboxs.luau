--TODOS
--1. add anti cheat

--<< Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Vide = require(ReplicatedStorage.Shared.Packages.vide)
local cleanup = Vide.cleanup
local action = Vide.action
local create = Vide.create
local source = Vide.source
local switch = Vide.switch
local mount = Vide.mount

--<< Private Variables
local visible = source(true)
local playerConnections = {}
local playerHitboxs: { [Player]: Part } = {}

--<< Private Functions
local function createHitbox(player: Player, position: Vide.Source<Vector3>, cleanupFn: () -> ())
	return mount(function()
		return create("Part")({
			Name = "HITBOX",
			Color = Color3.fromRGB(255, 0, 0),
			Anchored = true,
			CanCollide = false,
			Size = Vector3.new(3.5, 6, 3.5),
			Position = position,
			Transparency = switch(visible)({
				[true] = function()
					return 0.25
				end,
				[false] = function()
					return 1
				end,
			}),
			action(function(hitbox: Part)
				playerHitboxs[player] = hitbox
				cleanup(function()
					cleanupFn()
					hitbox:Destroy()
				end)
			end),
		})
	end, workspace)
end

--<< Global Functions
local module = {}

function module:Start()
	for _, player: Player in Players:GetPlayers() do
		self:playerAdded(player)
	end

	Players.PlayerAdded:Connect(function(player: Player)
		self:playerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		playerConnections[player]()
	end)
end

function module:playerAdded(player: Player)
	local character = player.Character
	if character then
		for _, instance: Instance in character:GetChildren() do
			if instance:IsA("BasePart") then
				instance.CollisionGroup = "Player"
			end
		end
	end

	player.CharacterAdded:Connect(function(newCharacter)
		for _, instance: Instance in newCharacter:GetChildren() do
			if instance:IsA("BasePart") then
				instance.CollisionGroup = "Player"
			end
		end
	end)

	local currentCharactersPosition = source(Vector3.new(0, 0, 0))
	local connection = RunService.Heartbeat:Connect(function()
		local character = player.Character
		if character and character.PrimaryPart then
			currentCharactersPosition(character.PrimaryPart.Position)
		end
	end)

	playerConnections[player] = createHitbox(player, currentCharactersPosition, function()
		connection:Disconnect()
	end)
end

function module:toggleHitboxs(toggle: boolean)
	visible(toggle)
end

function module:isHitboxShown(): boolean
	return visible()
end

function module:getAllHitboxs(filter: (player: Player, hitbox: Part) -> ()): { Part }
	local out = {}
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
