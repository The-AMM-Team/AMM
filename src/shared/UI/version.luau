---<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

--<< Types
type props = {
	scope: Fusion.Scope<typeof(Fusion)>,
	version: number?,
	AnchorPoint: Vector2?,
	Position: UDim2?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
}

return function(props: props): Fusion.Child

	local textTransparencyValue = props.scope:Value(0.5)

	return props.scope:New "Frame" {

		Size = UDim2.fromScale(1, 0.045),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,

		BackgroundTransparency = 1,

		[Children] = {

			props.scope:New "UIListLayout" {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = props.HorizontalAlignment,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},

			props.scope:New "TextLabel" {
				Size = UDim2.fromScale(0.065, 0.7),
	
				BackgroundTransparency = 1,
	
				Text = props.version or "nil :/",
				TextScaled = true,
				TextTransparency = props.scope:Spring(textTransparencyValue, 1, 0.5),
				FontFace = Font.fromEnum(Enum.Font.GothamBold),
				TextColor3 = Color3.fromRGB(255, 255, 255),
	
				[OnEvent "MouseEnter"] = function()
					textTransparencyValue:set(0)
				end,
	
				[OnEvent "MouseLeave"] = function()
					textTransparencyValue:set(0.5)
				end,
			},

		}

	}

end