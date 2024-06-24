--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type gun = {

	displayName: string,
	image: string,

	model: MeshPart,
	offset: Vector3,

	canDelete: boolean,
	raitity: string,
}

return {

	["default"] = {

		displayName = "Default Gun",
		image = "",

		model = ReplicatedStorage.Models.Guns.default,
		offset = Vector3.new(1.2, 0, 0),

		canDelete = false,
		raitity = "common",
	},

	["lilFlame"] = {

		displayName = "lil flame",
		image = "rbxassetid://17685231341",

		model = ReplicatedStorage.Models.Guns.lilflame,
		offset = Vector3.new(1.2, 0, 0),

		canDelete = true,
		raitity = "legendary",
	},
}
