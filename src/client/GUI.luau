--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Input = require(script.Parent.Input)

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

return module