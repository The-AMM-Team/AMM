--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Remotes
local clientNet = require(script.Parent.clientNet)

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)

local role = require(ReplicatedStorage.Shared.UI.role)

local module = {}

function module:Start()
	clientNet.Round.SetCallback(function(roundInfo)
		warn(roundInfo)
		if roundInfo.started then
			role(fusion.scoped(fusion), {
				role = roundInfo.role,
			})
		end
	end)
end

return module
