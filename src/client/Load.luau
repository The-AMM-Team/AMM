--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Sound = require(ReplicatedStorage.Shared.Sound)
local Settings = require(script.Parent.Settings)

local module = {}

function module:Start(debug: true?)
	local loadingThings: { [string]: (debug: true?) -> () } = {
		["Sound"] = Sound.loadAllSounds,
	}

	for name: string, func: (debug: true?) -> () in loadingThings do
		print(`Loading {name}!`)
		func(debug)
	end
end

return module
