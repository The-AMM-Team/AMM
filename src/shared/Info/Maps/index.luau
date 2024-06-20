--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

export type map = {

	name: string,
	spawns: Folder,
	components: { Types.component },

}

return {
	require(script.Parent.Hotel),
} :: {map}
