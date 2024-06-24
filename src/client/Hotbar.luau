--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Animation = require(script.Parent.Animation)
local Round = require(script.Parent.Round)
local Input = require(script.Parent.Input)

local hotbar = require(ReplicatedStorage.Shared.UI.hotbar)

--<< Remotes
local ClientRemotes = require(ReplicatedStorage.Shared.Remotes.ClientRemotes)
local Equip = ClientRemotes.Equip
local Unequip = ClientRemotes.Unequip

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)

--<< Private Variables
local equipped = Fusion.Value({}, 0)

local module = {}

function module:Start()
    
    hotbar {
        shown = Fusion.Computed({}, function(use, scope)  
            return if use(Round:getRoundState()) == nil then
                false
            elseif use(Round:getRoleState()) then
                true
            else 
                false
        end),
        equipped = equipped,
        role = Round:getRoleState()
    }

    local animation 

    Fusion.Observer({}, Round:getRoundState()):onChange(function()  
        if animation then
            animation()
        end
    end)

    Fusion.Observer({}, equipped):onChange(function()  
        if Fusion.peek(equipped) == 0 then
            animation()
            Unequip.Fire()
        else
            Equip.Fire()
            if Round:getRole() == "murderer" then
                animation = Animation:playAnimationOnPlayer("knifeIdle1")
            elseif Round:getRole() == "sheriff" then
                animation = Animation:playAnimationOnPlayer("GunIdle1")
            end
        end
    end)

    Input:bindToInput(Enum.KeyCode.One, function()  
        if Fusion.peek(equipped) == 1 then
            equipped:set(0)
        else
            equipped:set(1)
        end
    end)

end

return module