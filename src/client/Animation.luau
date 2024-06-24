--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

--<< Modules
local Debug = require(ReplicatedStorage.Shared.Debug)
local Character = require(ReplicatedStorage.Shared.Character)

--<< Private Ids 
local animations: {[string]: number} = {

    ["knifeSwing1"] = 16884031100,
    ["knifeIdle1"] = 16882019560,
    
    ["GunIdle1"] = 17224465048

}

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

function module.loadAllAnimation(showDebugInfo: boolean?): ()
	local folder = Instance.new("Folder", workspace)
	folder.Name = "Loading Animations"

	local allAnimationInstances: { Animation } = {}
	for name: string, id: number in animations do
		local animation: Animation = Instance.new("Animation", folder)
		animation.AnimationId = `rbxassetid://{id}`
		table.insert(allAnimationInstances, animation)

		if showDebugInfo then
			print(`Started Loading: {name}`)
		end
	end

	print(
		`Animations took: {Debug:timeFunctionCall(ContentProvider.PreloadAsync, ContentProvider, allAnimationInstances)}s to load!`
	)
end

-- Plays a animation on the player
function module:playAnimationOnPlayer(id: string): () -> ()

    local humanoid: Humanoid? = Character:getPlayersHumanoid(Players.LocalPlayer) :: Humanoid?
    local animationTrack: AnimationTrack? = nil
    if humanoid then
        local animator: Animator? = humanoid:FindFirstChild("Animator") :: Animator?
        if animator then
            animationTrack = animator:LoadAnimation(createAnimation(animations[id]))
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