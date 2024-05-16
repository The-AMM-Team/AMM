local ReplicatedStorage = game:GetService("ReplicatedStorage")
--<< Services

--<< Modules

--<< Remotes
local clientNet = require(script.Parent.clientNet)

--<< Packages
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local Value = Fusion.Value

--<< Types
type module = {
    round: Fusion.Value<boolean>,
    currentRole: Fusion.Value<string?>,
    crateResult: Signal.Signal<string>,

    Start: (self: module) -> ()
}

--<< Public Variables
local module: module = {
    
    round = Value(false),
    currentRole = Value(),

    crateResult = Signal.new()

} :: module

--<< Public Functions
function module:Start()
    
    clientNet.Round.SetCallback(function(roundInProgress: boolean)
        self.round:set(roundInProgress)
        if not self.round:get() then
            self.currentRole:set(nil) 
        end
    end)

    clientNet.Role.SetCallback(function(role: string)
        self.currentRole:set(role)
    end)

    clientNet.CrateResult.SetCallback(function(item: string)  
        self.crateResult:Fire(item)
    end)

end

return module