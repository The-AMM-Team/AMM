--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return {

	["default"] = {

		displayName = "Default Gun",
		image = "",

		model = ReplicatedStorage.Models.Guns.default,
		offset = Vector3.new(-1.2, 0, 0),

		canDelete = false,
		raitity = "common",
	},

	["lilFlame"] = { 

		displayName = "lil flame",
		image = "",

		model = ReplicatedStorage.Models.Guns.lilflame,
		offset = Vector3.new(-1.2, 0, 0),

		canDelete = true,
		raitity = "legendary",
	},
}
