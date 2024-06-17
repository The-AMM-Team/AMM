--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Chance = require(ReplicatedStorage.Shared.Chance)

--<< Packages
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)

--<< Types
type rolesTableFormat = {
	sheriff: Player?,
	murderer: Player?,
	innocent: { Player },
}

type roles = "sheriff" | "murderer" | "innocent"

--<< Private Functions
local function createRoleTables(sheriff: Player, murderer: Player, innocent: { Player }): rolesTableFormat
	return {
		sheriff = sheriff,
		murderer = murderer,
		innocent = innocent,
	}
end

--<< Public Variables
local module = {

	onRolesAdded = Signal.new(),

	playersCurrentChanceOfMurderer = {},
}

--<< Public Functions
function module:Start()
	Players.PlayerAdded:Connect(function(player)
		self.playersCurrentChanceOfMurderer[player] = 2
	end)

	Players.PlayerRemoving:Connect(function(player)
		self.playersCurrentChanceOfMurderer[player] = nil
	end)
end

function module:generateRoles(playersInRound: { Player })
	playersInRound = table.clone(playersInRound)

	assert(#playersInRound >= 2, "Need to have 2 players")

	local murderer: Player = Chance(self.playersCurrentChanceOfMurderer)
	table.remove(playersInRound, table.find(playersInRound, murderer))

	local sheriff: Player = playersInRound[math.random(1, #playersInRound)]
	table.remove(playersInRound, table.find(playersInRound, sheriff))

	self.currentPlayersRoles = createRoleTables(sheriff, murderer, playersInRound)
	self.onRolesAdded:Fire(table.clone(self.currentPlayersRoles))
end

function module:getAllChances(): number
	local amount = 0
	for _, chance in self.playersCurrentChanceOfMurderer do
		amount += chance
	end
	return amount
end

function module:increaseAllPlayersChancesEvenly()
	-- Get all chances out of 100 and then divided by players
	local chance = (100 - self:getAllChances()) / #Players:GetPlayers()

	for _, player in Players:GetPlayers() do
		self:setPlayerMurdererChance(player, self:getPlayerCurrentMurdererChance(player) + chance)
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

	if not currentRoles then
		return nil
	end

	return if currentRoles.murderer == player
		then "murderer"
		elseif currentRoles.sheriff == player then "sheriff"
		elseif table.find(currentRoles.innocent, player) then "innocent"
		else nil
end

function module:getAllRoles(): rolesTableFormat?
	return self.currentPlayersRoles
end

function module:resetAllRoles()
	local roles = self:getAllRoles()

	self:setPlayerMurdererChance(roles.murderer, 0)
	self:increaseAllPlayersChancesEvenly()

	self.currentPlayersRoles = nil
end

function module:getMurderer(): Player?
	local currentRoles = self:getAllRoles()
	return if currentRoles then currentRoles["murderer"] else nil
end

function module:getSheriff(): Player?
	local currentRoles = self:getAllRoles()
	return if currentRoles then currentRoles["sheriff"] else nil
end

function module:getInnocent(): { Player }?
	local currentRoles = self:getAllRoles()
	return if currentRoles then currentRoles["innocent"] else nil
end

function module:getCurrentPlayersRole(): rolesTableFormat?
	return self.currentPlayersRoles
end

return module
