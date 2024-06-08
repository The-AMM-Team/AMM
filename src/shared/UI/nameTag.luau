--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Roles = require(ReplicatedStorage.Shared.Info.Roles)

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local Children = Fusion.Children
local Safe = Fusion.Safe

--<< Types
type props = {
    player: Player,
    head: BasePart,
    roles: {string}
}

return function(scope: Fusion.Scope<typeof(Fusion)>, props: props): any
    
    local nametagScope = scope:innerScope()

    return nametagScope:New "BillboardGui" {
       
            ExtentsOffset = Vector3.new(0, 2, 0),
            MaxDistance = 15,
            Size = UDim2.fromScale(5, 1),
 
            [Children] = {

                nametagScope:New "Frame" {
                
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
        
                    [Children] = {

                        nametagScope:New "Frame" {
        
                            AnchorPoint = Vector2.new(0.5, 1),
                            BackgroundTransparency = 1,
                            Position =  UDim2.fromScale(0.5, 1),
                            Size = UDim2.fromScale(0.8, 0.4),    
            
                            [Children] = {

                                nametagScope:New "UIListLayout" {
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Center
                                },

                                nametagScope:ForValues(props.roles, function(name: string, _: number)
                                    return Safe {

                                        try = function()
                                            return nametagScope:New "TextLabel" {
                                                BackgroundTransparency = 1,
                                                Size = UDim2.fromScale(0.4, 0.75),
                                                FontFace = Font.fromEnum(Enum.Font.GothamBold),
                                                Text = Roles[name].name,
                                                TextColor3 = Roles[name].color,
                                                TextScaled = true,
                    
                                                [Children] = {
                                                    nametagScope:New "UIStroke" {
                                                        Thickness = 5
                                                    }        
                                                }
            
                                            }
                                        end,

                                        fallback = function(err: string)
                                            return nametagScope:New "TextLabel" {
                                                BackgroundTransparency = 1,
                                                Size = UDim2.fromScale(0.4, 0.75),
                                                FontFace = Font.fromEnum(Enum.Font.GothamBold),
                                                Text = err,
                                                TextColor3 = Color3.fromRGB(255, 0, 0),
                                                TextScaled = true,
                    
                                                [Children] = {
                                                    nametagScope:New "UIStroke" {
                                                        Thickness = 5
                                                    }        
                                                }
            
                                            }
                                        end
                                        
                                    }
                                end)

                            }
            
                        },
            
                        nametagScope:New "TextLabel" {
                            
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(1, 0.475),
                            FontFace = Font.fromEnum(Enum.Font.GothamBold),
                            Text = props.player.DisplayName,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextScaled = true,
   
                            [Children] = {
                                nametagScope:New "UIStroke" {
                                    Thickness = 5
                                }
                            }

                        }

                    },
        
                }
            }

    } 
end