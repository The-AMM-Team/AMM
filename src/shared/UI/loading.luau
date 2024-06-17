--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local Children = fusion.Children
local peek = fusion.peek
local scoped = fusion.scoped

--<< Types
type loadFunctions = { [string]: () -> () }


return function(loadFunctions: loadFunctions)
	
    local loadingScope = scoped(fusion)

	local progress = loadingScope:Value(0)
	local progressText = loadingScope:Value("Loading...")
	
    loadingScope:New "ScreenGui" {
        DisplayOrder = 3,
        IgnoreGuiInset = true,
        Parent = Players.LocalPlayer.PlayerGui,

        [Children] = {

            loadingScope:New "Frame" {
        
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
        
                BackgroundTransparency = 1,
        
                [Children] = {
                    
                    loadingScope:New "TextLabel" {
                        
                        Size = UDim2.fromScale(1, 0.25),
                        AnchorPoint = Vector2.new(0.5, 0.5), 
                        Position = UDim2.fromScale(0.5, 0.35),
        
                        BackgroundTransparency = 1,
        
                        Text = "Another Murderer Mystery?",
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        FontFace = Font.fromEnum(Enum.Font.GothamBold),
                        TextScaled = true,
        
                        ZIndex = 2,
                        
                    },
                    
                    loadingScope:New "Frame" {
                    
                        Size = UDim2.fromScale(0.75, 0.05),
                        AnchorPoint = Vector2.new(0.5, 0.5), 
                        Position = UDim2.fromScale(0.5, 0.675),
                        
                        BackgroundTransparency = 0.95,
                        
                        ZIndex = 2,
                        
                        [Children] = loadingScope:New "Frame" {
                            
                            Size = loadingScope:Spring(loadingScope:Computed(function(use)  
                                return UDim2.fromScale(use(progress)/100, 1)	
                            end), 25, 0.5),
                            
                        }
                        
                    },
                    
                    loadingScope:New "TextLabel" {
                        
                        Size = UDim2.fromScale(1, 0.05),
                        AnchorPoint = Vector2.new(0.5, 0.5), 
                        Position = UDim2.fromScale(0.5, 0.875),
                        
                        BackgroundTransparency = 1,
                        
                        Text = progressText,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        FontFace = Font.fromEnum(Enum.Font.GothamBold),
                        TextScaled = true,
                        
                        ZIndex = 2,
                        
                    },
                    
                    loadingScope:New "Frame" {
        
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.fromScale(0, 0.5),
                        Size = UDim2.fromScale(1, 1),
        
                        BackgroundColor3 = Color3.fromRGB(29, 29, 29),
        
                    }
                    
                }
                    
            }

        }

    }

    local totalContents = 0
		
	for _: string, _: (string) -> () in loadFunctions do			
        totalContents += 1
    end
		
	local gainAmount = 100 / totalContents
		
	for name: string, func in loadFunctions do
		progressText:set(name)
		func()
		progress:set(peek(progress) + gainAmount)
	end
		
	progressText:set("Finished!")

    task.wait(2)

    fusion.doCleanup(loadingScope)

end
