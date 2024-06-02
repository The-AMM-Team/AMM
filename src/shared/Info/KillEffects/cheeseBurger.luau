--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Sound = require(ReplicatedStorage.Shared.Sound)

--<< Private Variables
local burgerModel: BasePart = ReplicatedStorage.Models.Effects.Burger

--<< Private Functions
local function createBurger(position: Vector3): BasePart
	local clonedBurger: BasePart = burgerModel:Clone()
	clonedBurger.Position = position
	clonedBurger.Parent = workspace
	clonedBurger.Anchored = false

	task.delay(5, function()
		if clonedBurger then
			clonedBurger:Destroy()
		end
	end)

	return clonedBurger
end

return function(_: Player, deadPlayer: Player)
	local character = deadPlayer.Character

	if character then
		local humanoidRootPart: BasePart? = character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			local burger = createBurger(humanoidRootPart.Position)
			Sound:playSoundOnPart("cheeseBurger", burger, {
				volume = 1,
				async = true,
			})
		end
	end
end
