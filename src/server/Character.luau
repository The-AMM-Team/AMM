--<< Services
local Players = game:GetService("Players")

local module = {}

function module:Start()
    
    for _, player: Player in Players:GetPlayers() do
        self:playerAdded(player)
    end

    Players.PlayerAdded:Connect(function(player)
        self:playerAdded(player)
    end)

end

function module:playerAdded(player: Player)
    
    local character: Model = player.Character or player.CharacterAdded:Wait()

    for _, instance: Instance in character:GetChildren() do
        if instance:IsA("BasePart") then
            instance.CollisionGroup = "Player" 
        end
    end

end

function module:getPlayersHumanoid(player): Humanoid?
    local character: Model? = player.Character
    if character then
        return character:FindFirstChild("Humanoid") :: Humanoid
    end
end

function module:getPlayersHumanRootPart(player: Player): Part?
    local character: Model? = player.Character
    if character then
        return character.PrimaryPart :: Part
    end
end

return module
