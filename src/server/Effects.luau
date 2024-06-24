--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules

--<< Remotes

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)

--<< Types
type settings = {
	destoryDelay: number,
}

--<< Private Variables

--<< Private Functions

--<< Public Variables
local module = {}

--<< Public Functions
function module:gunTrail(orgin: Vector3, hit: Vector3, settings: settings)

	local partTransparency = Fusion.Value({}, 0.75)
	local partTransparencyTween = Fusion.Tween({}, partTransparency, TweenInfo.new(1, Enum.EasingStyle.Linear))

	local trail = Fusion.New({}, "Part")({
		Parent = workspace,
		Size = Vector3.new(0.1, 0.1, (orgin - hit).Magnitude),
		Transparency = partTransparencyTween,
		Anchored = true,
		CanCollide = false,
		CFrame = CFrame.lookAt(orgin, hit) * CFrame.new(0, 0, -(orgin - hit).Magnitude / 2),
	})

	partTransparency:set(settings.destoryDelay)

	task.delay(settings.destoryDelay, function()
		trail:Destroy()
	end)

end

function module:displayImageAboveSomethingWithAFade(position: Vector3, Size: Vector3, image: string)
	
end

return module
