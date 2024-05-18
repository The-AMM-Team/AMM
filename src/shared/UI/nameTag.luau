---<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Roles = require(ReplicatedStorage.Shared.Info.Roles)

--<< Packages
local Vide = require(ReplicatedStorage.Shared.Packages.vide)

local mount = Vide.mount
local create = Vide.create
local indexes = Vide.indexes
local source = Vide.source

--<< Types
type props = {
    playerName: string,
    head: BasePart,
    roles: {string}
}

return function(props: props): Frame
    return mount(function()
        return create "BillboardGui" {
            ExtentsOffset = Vector3.new(0, 2, 0),
            MaxDistance = 15,
            Size = UDim2.fromScale(5, 1),
    
            create "Frame" {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
    
                create "Frame" {
    
                    AnchorPoint = Vector2.new(0.5, 1),
                    BackgroundTransparency = 1,
                    Position =  UDim2.fromScale(0.5, 1),
                    Size = UDim2.fromScale(0.8, 0.4),    
    
                    create "UIListLayout" {
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    },
    
                    indexes(source(props.roles), function(name: string, index: number)
                        print(name, index)
                        return create "TextLabel" {
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(0.4, 0.75),
                            FontFace = Font.fromEnum(Enum.Font.GothamBold),
                            Text = Roles[name()].name,
                            TextColor3 = Roles[name()].color,
                            TextScaled = true,

                            create "UIStroke" {
                                Thickness = 5
                            }        
                        }
                    end)
    
                },
    
                create "TextLabel" {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0.475),
                    FontFace = Font.fromEnum(Enum.Font.GothamBold),
                    Text = props.playerName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextScaled = true,

                    create "UIStroke" {
                        Thickness = 5
                    }
                }
    
            }
        }
    end, props.head) 
end