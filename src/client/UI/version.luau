--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)

local New = Fusion.New
local Children = Fusion.Children

local OnEvent = Fusion.OnEvent

local Value = Fusion.Value
local Spring = Fusion.Spring

--<< Types
type props = {
    parent: ScreenGui,
    version: number,
    
    AnchorPoint: Vector2,
    Position: UDim2, 
    HorizontalAlignment: Enum.HorizontalAlignment, 
}

return function(props: props): Frame
    
    local TextTransparencyValue = Value(0.5)

    return New "Frame" {

        Parent = props.parent,

        Size = UDim2.fromScale(1, 0.04),
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,

        [Children] = {

            New "UIListLayout" {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = props.HorizontalAlignment,
                VerticalAlignment = Enum.VerticalAlignment.Center
            },

            New "TextLabel" {

                Size = UDim2.fromScale(0.065, 0.7),

                BackgroundTransparency = 1,

                Text = props.version,
                TextScaled = true,
                TextTransparency = Spring(TextTransparencyValue, 25, 0.5),
                FontFace = Font.fromEnum(Enum.Font.GothamBold),
                TextColor3 = Color3.fromRGB(255, 255, 255),

                [OnEvent "MouseEnter"] = function()
                    TextTransparencyValue:set(0)
                end,

                [OnEvent "MouseLeave"] = function()
                    TextTransparencyValue:set(0.5)
                end

            }

        }

    }

end