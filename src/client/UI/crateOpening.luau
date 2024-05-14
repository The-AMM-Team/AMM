--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Crates = require(ReplicatedStorage.Shared.Crates)
local Chance = require(ReplicatedStorage.Shared.Chance)

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)

local New = Fusion.New
local Children = Fusion.Children
 
local OnEvent = Fusion.OnEvent

local Value = Fusion.Value
local Tween = Fusion.Tween
local Spring = Fusion.Spring

local ForPairs = Fusion.ForPairs

--<< Types
type props = {
    
    parent: ScreenGui,

    rollingTime: number,
    crate: string,
    gyattItem: string,

    cleanup: () -> (),

}

--<< Private Functions
local function slot(rollingTime: number, index: number, name: string)

    local frameSizeValue = Value(UDim2.fromScale(0.172, 0.765)) 
    local frameColorValue = Value(Color3.fromRGB(40, 40, 40))
    if index == 80 then
        task.delay(rollingTime, function()
            frameColorValue:set(Color3.fromRGB(61, 61, 61))
            frameSizeValue:set(UDim2.fromScale(0.198, 0.856))
        end)
    end

    return New "Frame" {

        ZIndex = index,

        Size = Spring(frameSizeValue, 25, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        
        BackgroundTransparency = 1,

        [Children] = {
        
            New "ImageLabel" {

                Size = UDim2.fromScale(1.9, 1.9),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                
                BackgroundTransparency = 1,
                Image = "rbxassetid://7498352732",
                ImageColor3 = Color3.fromRGB(59, 59, 59),
                
                [Children] = {
                    New "UICorner" {
                        CornerRadius = UDim.new(0.05, 0),
                    }
                }

            },
--
            New "TextLabel" {

                ZIndex = 3,
                Size = UDim2.fromScale(1, 0.2),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundTransparency = 1,
                
                Text = name,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,

            },
            
            New "Frame" {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Spring(frameColorValue, 25, 0.5),
                [Children] = {
                    New "UICorner" {
                        CornerRadius = UDim.new(0.025, 0),
                    }
                }
            }
        }
    }
end

return function(props: props)

    local randomItems = {}
    for index = 1, 100 do
        randomItems[index] = Chance(Crates[props.crate].items)
        
        if index == 80 then
            randomItems[index] = props.gyattItem
        end
    end

    local randomItemsValue = Value(randomItems)

    local mainFrameSizeValue = Value(UDim2.fromScale(0, 0))
--
    local skipButtonTextTransparencyValue = Value(0.5)
    local crateHolderPositionValue = Value(UDim2.fromScale(0.5, 0.5))

    local skipButtonSizeValue = Value(UDim2.fromScale(0, 0))

    local out 
    out = New "Frame" {

        Parent = props.parent,

        Size = Spring(mainFrameSizeValue, 25, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.05,

        [Children] = {

            New "UIAspectRatioConstraint" {
                AspectRatio = 4.453,
                AspectType = Enum.AspectType.FitWithinMaxSize
            },

            New "UICorner" {
                CornerRadius = UDim.new(0.05, 0),
            },

            New "Frame" {
                
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundTransparency = 1,
                ClipsDescendants = true,

                [Children] = {

                    New "Frame" {
                
                        Size = UDim2.fromScale(1, 1),
                        Position = Tween(crateHolderPositionValue, TweenInfo.new(props.rollingTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)),
                        AnchorPoint = Vector2.new(0.5, 0.5),
        
                        BackgroundTransparency = 1,
        
                        [Children] = {
        
                            New "UIListLayout" {
                                Padding = UDim.new(0.025, 0),
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                            },
                            
                            ForPairs(randomItemsValue, function(index: number, value: string)
                                return index, slot(props.rollingTime, index, value)
                            end, Fusion.Cleanup),
        
                        }
        
                    }

                }

            },

            New "Frame" {
                
                Size = Spring(skipButtonSizeValue, 25, 0.75),
                Position = UDim2.fromScale(0.5, 1.3),
                AnchorPoint = Vector2.new(0.5, 0.5),
                
                BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                BackgroundTransparency = 0.05,

                [Children] = {

                    New "UICorner" {
                        CornerRadius = UDim.new(0.15, 0),
                    },

                    New "TextButton" {
                        Size = UDim2.fromScale(1, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),

                        BackgroundTransparency = 1,

                        Text = "Claim", 
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextTransparency = Spring(skipButtonTextTransparencyValue, 25, 0.5),
                        TextScaled = true,
                        TextWrapped = true,

                        [OnEvent "MouseEnter"] = function()
                            skipButtonTextTransparencyValue:set(0.1)
                        end,

                        [OnEvent "MouseLeave"] = function()
                            skipButtonTextTransparencyValue:set(0.5)
                        end,

                        [OnEvent "Activated"] = function()
                            skipButtonSizeValue:set(UDim2.fromScale(0, 0))
                            mainFrameSizeValue:set(UDim2.fromScale(0, 0))
                            out:Destroy()
                            props.cleanup()
                        end 

                    },

                },

            },

        },

    }

    mainFrameSizeValue:set(UDim2.fromScale(0.5, 0.2))

    task.wait(1)

    crateHolderPositionValue:set(UDim2.fromScale(-5.31, 0.5))

    task.wait(props.rollingTime)

    skipButtonSizeValue:set(UDim2.fromScale(0.225, 0.275))


end