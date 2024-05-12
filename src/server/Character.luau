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

return module
