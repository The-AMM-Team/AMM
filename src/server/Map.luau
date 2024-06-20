--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local ListOfMaps = require(ReplicatedStorage.Shared.Info.Maps.index)

--<< Private Variables
local currentMap = nil

--<< Public Variables
local module = {}

--<< Public Functions
function module:getRandomMap() -- makwe a type for this
	return ListOfMaps[math.random(1, #ListOfMaps)]
end

function module:loadMap(players)
	currentMap = self:getRandomMap()

	for _, component in currentMap.components do
		component:load()
	end

	self:spawnPlayersInsideMap(players)
end

function module:unloadMap()
	if currentMap then
		for _, component in currentMap.components do
			component:unload()
		end
		currentMap = nil
	end
end

function module:getCurrentMap(): ListOfMaps.map?
	return currentMap
end

function module:spawnPlayersInsideMap(players: { Player }): ()
	if not currentMap then
		warn("No map")
		return
	end

	local spawns: { Part } = currentMap.spawns:GetChildren()

	assert(#spawns >= 12, "Map needs more than 12")

	for _, player in players do
		local character: Model? = player.Character

		if character then
			local index = math.random(1, #spawns)
			character:PivotTo(spawns[index].CFrame)
			table.remove(spawns, index)
		end

		-- TODO add some cool effect when you join the map or something :)))
	end
end

return module
