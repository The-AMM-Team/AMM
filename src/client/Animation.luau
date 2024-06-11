--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Character = require(ReplicatedStorage.Shared.Character)

--<< Private Functions
local function createAnimation(id: number): Animation
    local out: Animation = Instance.new("Animation")
    out.AnimationId = `rbxassetid://{id}`
    return out
end

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()

end

-- Plays a animation on the player
function module:playAnimationOnPlayer(id: number): () -> ()

    local humanoid: Humanoid? = Character:getPlayersHumanoid(Players.LocalPlayer) :: Humanoid?
    local animationTrack: AnimationTrack? = nil
    if humanoid then
        local animator: Animator? = humanoid:FindFirstChild("Animator") :: Animator?
        if animator then
            animationTrack = animator:LoadAnimation(createAnimation(id))
            if animationTrack then
                animationTrack:Play()
            end
        end
    end

    return function()
        if animationTrack then
            animationTrack:Stop() 
        end
    end

end

return module