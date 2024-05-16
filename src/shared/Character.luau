--<< Services
local Players = game:GetService("Players")

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
    
    for _, player: Player in Players:GetPlayers() do
        self:playerAdded(player)
    end

    Players.PlayerAdded:Connect(function(player)
        self:playerAdded(player)
    end)
    
end

function module:playerAdded(player: Player)
    
    local character: Model? = player.Character

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

function module:getBodyPartFromCharacter(player: Player, bodyPart): BasePart?
    local character = player.Character
    if character then
        return character:FindFirstChild(bodyPart) :: Humanoid
    end
end


return module
