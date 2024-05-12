--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Input = require(script.Parent.Input)

--<< Private Functions
local function createScreen(): ScreenGui
    local screen = Instance.new("ScreenGui")
    screen.IgnoreGuiInset = true
    screen.Parent = Players.LocalPlayer.PlayerGui
    screen.Name = "MAIN"
    return screen
end
--<< Global Variables
local module = {
    screen = createScreen()
}

--<< Global Functions
function module:Start()

    self:version()

end

function module:version()
    
    local versionUI = require(script.Parent.UI.version)

    local version = "v0.0.1"
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

return module