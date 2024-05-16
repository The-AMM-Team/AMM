--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Input = require(script.Parent.Input)
local Camera = require(script.Parent.Camera)
local Animation = require(script.Parent.Animation)
local ClientState = require(script.Parent.ClientState)

--<< Remotes
local clientNet = require(script.Parent.clientNet)

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local Value = Fusion.Value
local Observer = Fusion.Observer
local New = Fusion.New
local Spring = Fusion.Spring

--<< Private Functions
local function createScreen(): ScreenGui
    local screen = Instance.new("ScreenGui")
    screen.ResetOnSpawn = false
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
    self:hotbar()

    self:crateOpening()

    Input:bindToInput(Enum.KeyCode.E, function()
        clientNet.OpenCrate.Fire("wooden")
	end)

end

function module:hotbar()
    
    local animation: () -> ()? = nil

    local equipped = Value(false)
    Observer(equipped):onChange(function()  
        if not equipped:get() and animation then
            animation()
        end
    end)

    Observer(ClientState.round):onChange(function()  
        if not ClientState.round:get() then
            equipped:set(false)
            clientNet.Unequip.Fire()
        end
    end)

    Input:bindToInput(Enum.KeyCode.One, function()
        local currentlyInRound = ClientState.round:get()
        local currentRole =  ClientState.currentRole:get()
        
        if not currentlyInRound or currentRole == "innocent" then return end

        if equipped:get() then
            clientNet.Unequip.Fire()
        else
            if currentRole == "sheriff" then
                animation = Animation:playAnimationOnPlayer(17224465048)
            else
                animation = Animation:playAnimationOnPlayer(16882019560)
            end
            
            clientNet.Equip.Fire()
        end
        equipped:set(not equipped:get())

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

function module:client()
    local clientUI = require(script.Parent.UI.client)

    clientUI {
        parent = self.screen
    }
end

function module:crateOpening()
    
    local openCrate= require(script.Parent.UI.crateOpening)

    ClientState.crateResult:Connect(function(item: string)  
        local cleanup = self:darkBackground()
        Camera:setCameraFieldOfView(50)
        openCrate {
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