--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local nameTag = require(ReplicatedStorage.UI.nameTag)

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

--<< Public Variables
local module = {}

--<< Public Functions
-- Create A better way to mount tags
function module:Start()
	local Database = require(game:GetService("ServerScriptService").Server.Database)

	Database.onDataLoaded:Connect(function(player: Player, data: Types.playerData)
		player.CharacterAdded:Connect(function(newCharacter)
			nameTag({
				head = self:getBodyPartFromCharacter(player, "Head"),
				playerName = player.Name,
				roles = data.roles,
			})
		end)
	end)
end

function module:getPlayersHumanoid(player): Humanoid?
	local character: Model? = player.Character
	if character then
		return character:FindFirstChild("Humanoid") :: Humanoid
	end
	return nil
end

function module:isHumanoidAlive(player: Player): boolean
	local humanoid: Humanoid? = self:getPlayersHumanoid(player)
	if humanoid then
		return humanoid.Health > 0
	end
	return false
end

function module:disableAllParticles(player: Player): ()
	local character = player.Character
	if character then
		for _, instance: Instance in character:GetDescendants() do
			if instance:IsA("ParticleEmitter") then
				instance:Destroy()
			end
		end
	end
end

function module:getAllPlayersParts(player: Player, filter: (part: MeshPart) -> ()): { MeshPart }?
	local out = {}
	local character = player.Character
	if character then
		for _, instance: Instance in character:GetDescendants() do
			if instance:IsA("MeshPart") then
				if filter then
					filter(instance)
				end
				table.insert(out, instance)
			end
		end
	else
		return nil
	end
	return out
end

function module:getBodyPartFromCharacter(player: Player, bodyPart): BasePart?
	local character = player.Character
	if character then
		return character:FindFirstChild(bodyPart) :: BasePart
	end
	return nil
end

return module
