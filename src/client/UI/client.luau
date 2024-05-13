--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)

local New = Fusion.New
local Children = Fusion.Children

--<< Types
type props = {
    parent: ScreenGui
}

return function(props)
    return New "Frame" {

        Parent = props.parent,

        Size = UDim2.fromScale(1, 0.075),
        Position = UDim2.fromScale(0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0),

        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,

        [Children] = {

            New "UIListLayout" {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center
            },

            New "TextLabel" {

                Size = UDim2.fromScale(0.25, 0.7),

                BackgroundTransparency = 1,

                Text = if RunService:IsStudio() then "STUDIO DEV ENVIRONMENT" else "",
                TextScaled = true,
                TextTransparency = 0,
                FontFace = Font.fromEnum(Enum.Font.GothamBlack),
                TextColor3 = Color3.fromRGB(143, 255, 160),

            }

        }

    }
end