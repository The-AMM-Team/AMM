--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Vide = require(ReplicatedStorage.Shared.Packages.vide)

local source = Vide.source
local mount = Vide.mount
local apply = Vide.apply
local spring = Vide.spring

--<< Private Variables
local fieldOfView = source(70)

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
	mount(function()
		return apply(workspace.CurrentCamera)({
			FieldOfView = spring(fieldOfView, 0.25, 0.5),
		})
	end)
end

function module:setCameraFieldOfView(amount: number)
	fieldOfView(amount)
end

return module
