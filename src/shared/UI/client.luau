---<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local Children = Fusion.Children

return function(scope: Fusion.Scope<typeof(Fusion)>): Fusion.Child
	return scope:New("TextLabel")({

		Size = UDim2.fromScale(1, 0.075),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),

		BackgroundTransparency = 1,

		Text = if RunService:IsStudio() then "STUDIO DEV ENVIRONMENT" else "",
		TextScaled = true,
		TextTransparency = 0.95,
		FontFace = Font.fromEnum(Enum.Font.GothamBlack),
		TextColor3 = Color3.fromRGB(143, 255, 160),

		[Children] = {

			scope:New("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			scope:New("TextLabel")({

				Size = UDim2.fromScale(0.4, 0.7),

				BackgroundTransparency = 1,
			}),
		},
	})
end
