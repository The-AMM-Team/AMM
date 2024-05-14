--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local Hydrate = Fusion.Hydrate
local Value = Fusion.Value
local Spring = Fusion.Spring

--<< Private Variables
local fieldOfView = Value(70)

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
    Hydrate(workspace.CurrentCamera) {
        FieldOfView = Spring(fieldOfView, 20, 0.75)
    }
end

function module:setCameraFieldOfView(amount: number)
    fieldOfView:set(amount)
end

return module