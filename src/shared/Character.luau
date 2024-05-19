--<< Public Variables
local module = {}

function module:bindCallbackToCharacter(player: Player, callback: (character: Model?) -> ()): RBXScriptConnection
	local character: Model? = player.Character
	if character then
		callback(character)
	end

	return player.CharacterAdded:Connect(function(newCharacter: Model)
		callback(newCharacter)
	end)
end

--<< Public Functions
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
