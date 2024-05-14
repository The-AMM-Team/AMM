--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Input = require(script.Parent.Input)
local Camera = require(script.Parent.Camera)

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local New = Fusion.New
local Spring = Fusion.Spring
local Value = Fusion.Value

--<< Remotes
local clientNet = require(script.Parent.clientNet)

--<< Private Functions
local function createScreen(): ScreenGui
    local screen = Instance.new("ScreenGui")
    screen.IgnoreGuiInset = true
    screen.Parent = Players.LocalPlayer.PlayerGui
    screen.Name = "MAIN"
    return screen
end
--<< Public Variables
local module = {
    screen = createScreen()
}

--<< Public Functions
function module:Start()
    
    self:version()
    self:client()
    self:role()

    self:crateOpen()

    Input:bindToInput(Enum.KeyCode.E, function()
        clientNet.OpenCrate.Fire("wooden")
	end)

end

function module:darkBackground(): () -> ()
    
    local backgroundTransparency = Value(1)

    local frame = New "Frame" {
        ZIndex = -1,
        Parent = self.screen,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = Spring(backgroundTransparency, 25, 0.75),
    } 
    
    backgroundTransparency:set(0.1)

    return function()
        backgroundTransparency:set(1)
        task.wait(2)
        frame:Destroy()    
    end 

end

function module:version()
    
    local versionUI = require(script.Parent.UI.version)

    local version = require(ReplicatedStorage.Shared.Version)
    local device = Input:getDevice()

    if device == "Phone" then
        versionUI {
            parent = self.screen,
            version = version,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            AnchorPoint = Vector2.new(0.5, 0),
            Position =  UDim2.fromScale(0.5, 0),
        }
    else
        versionUI {
            parent = self.screen,
            version = version,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            AnchorPoint = Vector2.new(0.5, 1),
            Position =  UDim2.fromScale(0.5, 1),
        }
    end
    
end

function module:role()
    clientNet.Role.SetCallback(function(role: string)  
        print(`You are {role}`)
    end)
end

function module:client()
    local clientUI = require(script.Parent.UI.client)

    clientUI {
        parent = self.screen
    }
end

function module:crateOpen()
    local crateOpening = require(script.Parent.UI.crateOpening)

    clientNet.CrateResult.SetCallback(function(item)
        warn(item)
        local cleanup = self:darkBackground()
        Camera:setCameraFieldOfView(50)
        crateOpening {
            parent = self.screen,
            rollingTime = 10,
            crate = "wooden",
            gyattItem = item,
            cleanup = function()
                Camera:setCameraFieldOfView(70)
                cleanup()
            end
        }        
    end)

end

return module