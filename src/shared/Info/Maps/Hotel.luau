--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

return {

	name = "Hotel",
	spawns = workspace.Hotel.Spawns,

	components = {

		{
			load = function()
				--print("Component system has been loaded")
			end,

			unload = function()
				--print("Component system has been unloaded")
			end,
		},
	},
} :: {

	name: string,
	spawns: Folder,
	components: { Types.component },
}
