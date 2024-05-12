--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal) 

--<< Types
type rolesTableFormat = {

    sheriff: Player?,
    murderer: Player?,
    innocent: {Player}

}

type roles = "sheriff" | "murderer" | "innocent"

--<< Private Variables

--<< Private Functions
local function getPlayersAsPercent(): number
    return 100 / #Players:GetPlayers()
end

local function getRandomWithChance<T>(rarities: {[T]: number}): T

    local randomNumber = Random.new()
    local counter = 0

    for _: T, chance: number in rarities do
        counter += chance
    end

    local chosennumber = randomNumber:NextNumber(0, counter)
    for name: T, chance: number in rarities do
        counter -= chance
        if chosennumber > counter then
            return name
        end
    end

end

local function createRoleTables(sheriff: Player, murderer: Player, innocent: {Player}): rolesTableFormat
    return {
        sheriff = sheriff,
        murderer = murderer,
        innocent = innocent,
    }
end

--<< Global Variables
local module = {

    onRolesAdded = Signal.new(),

    playersCurrentChanceOfMurderer = {},

}

--<< Global Functions
function module:Start()
    
    Players.PlayerAdded:Connect(function(player)
        self.playersCurrentChanceOfMurderer[player] = 2
    end)

    Players.PlayerRemoving:Connect(function(player)
        self.playersCurrentChanceOfMurderer[player] = nil
    end)

end

function module:generateRoles(playersInRound: {Player})

    playersInRound = table.clone(playersInRound)

    assert(#playersInRound >= 2, "Need to have 2 players")

    local murderer: Player = getRandomWithChance(self.playersCurrentChanceOfMurderer)
    table.remove(playersInRound, table.find(playersInRound, murderer))
    

    local sheriff: Player = playersInRound[math.random(1, #playersInRound)]
    table.remove(playersInRound, table.find(playersInRound, murderer))

    self.currentPlayersRoles = createRoleTables(sheriff, murderer, playersInRound)
    self.onRolesAdded:Fire(table.clone(self.currentPlayersRoles))

end

function module:increaseAllPlayersChancesEvenly(players: {Player})

    local totalAmountofPercent = math.random(1, getPlayersAsPercent() / 10)

    for _, player in players do
        self:setPlayerMurdererChance(player, self:getPlayerCurrentMurdererChance(player) + totalAmountofPercent)
    end

end

function module:setPlayerMurdererChance(player: Player, chance: number)
    self.playersCurrentChanceOfMurderer[player] = chance
end

function module:getPlayerCurrentMurdererChance(player): number
    return self.playersCurrentChanceOfMurderer[player]
end

function module:getPlayerRole(player: Player): roles?
    local currentRoles = self:getCurrentPlayersRole()
    
    if not currentRoles then return nil end 

    return if currentRoles.murderer == player then
        "murderer"
    elseif currentRoles.sheriff == player then
        "sheriff"
    elseif table.find(currentRoles.innocent, player) then
        "innocent" 
    else
        nil
end

function module:getAllRoles(): rolesTableFormat?
    return self.currentPlayersRoles
end

function module:resetAllRoles()

    local roles = self:getAllRoles()

    self:setPlayerMurdererChance(roles.murderer, 5)
    self:increaseAllPlayersChancesEvenly({roles.sheriff})
    self:increaseAllPlayersChancesEvenly(roles.innocent)

    self.currentPlayersRoles = nil
end

function module:getMurderer(): Player?
    local currentRoles = self:currentPlayersRoles()
    return if currentRoles then currentRoles["murderer"] else nil
end

function module:getSheriff(): Player?
    local currentRoles = self:currentPlayersRoles()
    return if currentRoles then currentRoles["sheriff"] else nil
end

function module:getInnocent(): {Player}?
    local currentRoles = self:currentPlayersRoles()
    return if currentRoles then currentRoles["innocent"] else nil
end

function module:getCurrentPlayersRole(): rolesTableFormat?
    return self.currentPlayersRoles
end



return module