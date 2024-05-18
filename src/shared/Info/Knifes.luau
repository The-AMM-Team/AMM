--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return {

	["default"] = {

		displayName = "Default Knife",
		image = "",

		model = ReplicatedStorage.Models.Knifes.default,
		offset = Vector3.new(-1.2, 0, 0),

		canDelete = false,
		raitity = "common",
	},

	["flameDragon"] = {

		displayName = "Flame Dragon",
		image = "",

		model = ReplicatedStorage.Models.Knifes.flameDragon,
		offset = Vector3.new(-1.2, 0, 0),

		canDelete = true,
		raitity = "legendary",
	},
}
