--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local ListOfMaps = require(ReplicatedStorage.Shared.Maps.List)

--<< Utils

--<< Packages

--<< Types

--<< Private Variables
local currentMap = nil

--<< Private Functions

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

    --TODO add coin spawning later

end

function module:unloadMap()
    
    if currentMap then

        for _, component in currentMap.components do
            component:unload()
        end

        currentMap = nil

    end

end

function module:spawnPlayersInsideMap(players: {Player}): ()
    
    if not currentMap then 
        warn("No map") 
        return 
    end

    local spawns: {Part} = currentMap.spawns:GetChildren()

    if #spawns == 0 then 
        error("need spawning areas", 2) 
    end
    warn(players)
    for _, player in players do
        warn(player)
        local character: Model? = player.Character

        if character then
            character:PivotTo(spawns[math.random(1, #spawns)].CFrame)
        end

        -- TODO add some cool effect when you join the map or something :)))

    end

end


return module