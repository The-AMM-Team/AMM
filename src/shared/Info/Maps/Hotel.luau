--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")



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
}
