--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type knife = {

	displayName: string,
	image: string,

	model: MeshPart,
	offset: Vector3,

	canDelete: boolean,
	raitity: string,
}

return {

	["default"] = {

		displayName = "Default Knife",
		image = "rbxassetid://14895358168",

		model = ReplicatedStorage.Models.Knifes.default,
		offset = Vector3.new(-1.2, 0, 0),

		canDelete = false,
		raitity = "common",
	},

	["flameDragon"] = {

		displayName = "Flame Dragon",
		image = "rbxassetid://14895358168",

		model = ReplicatedStorage.Models.Knifes.flameDragon,
		offset = Vector3.new(-1.2, 0, 0),

		canDelete = true,
		raitity = "legendary",
	},
}
