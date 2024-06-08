--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = fusion.scoped

--<< Private Variables
local cameraScope = scoped(fusion)
local fieldOfView = cameraScope:Value(70)

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
	return cameraScope:Hydrate(workspace.CurrentCamera)({
		FieldOfView = cameraScope:Spring(fieldOfView, 0.25, 0.5),
	})
end

function module:setCameraFieldOfView(amount: number)
	fieldOfView:set(amount)
end

return module
