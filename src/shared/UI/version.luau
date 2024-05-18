---<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Vide = require(ReplicatedStorage.Shared.Packages.vide)

local create = Vide.create
local source = Vide.source
local spring = Vide.spring

--<< Types
type props = {
	version: number,
	AnchorPoint: Vector2,
	Position: UDim2,
	HorizontalAlignment: Enum.HorizontalAlignment,
}

return function(props: props): Frame

	local TextTransparencySource = source(0.5)

	return create "Frame" {

		Size = UDim2.fromScale(1, 0.045),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,

		BackgroundTransparency = 1,

		create "UIListLayout" {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = props.HorizontalAlignment,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		},

		create "TextLabel" {
			Size = UDim2.fromScale(0.065, 0.7),

			BackgroundTransparency = 1,

			Text = props.version,
			TextScaled = true,
			TextTransparency = spring(TextTransparencySource, 1, 0.5),
			FontFace = Font.fromEnum(Enum.Font.GothamBold),
			TextColor3 = Color3.fromRGB(255, 255, 255),

			MouseEnter = function()
				TextTransparencySource(0)
			end,

			MouseLeave = function()
                TextTransparencySource(0.5)
			end,
		}
	}

end