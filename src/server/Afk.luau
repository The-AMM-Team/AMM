--<< Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

--<< Network
local serverNet = require(script.Parent.serverNet)
local input = serverNet.Input

--<< Private Variables
local timeToKick = (60 * 19)

local playersInputTimers = {}
local playersConnections = {}

local module = {}

function module:Start()
	for _: number, player: Player in Players:GetPlayers() do
		self:playerAdded(player)
	end

	Players.PlayerAdded:Connect(function(player: Player)
		self:playerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		local thread: thread? = playersConnections[player]
		if thread then
			task.cancel(thread)
			playersConnections[player] = nil
		end
	end)

	input.SetCallback(function(player: Player)
		playersInputTimers[player] = 0
	end)
end

function module:playerAdded(player: Player): ()
	playersInputTimers[player] = 0
	playersConnections[player] = task.spawn(function()
		while true do
			if playersInputTimers[player] >= timeToKick then
				TeleportService:Teleport(16315583333, player)
				break
			end
			playersInputTimers[player] += 1
			task.wait(1)
		end
	end)
end

function module:setPlayerAFKTime(player: Player, amount: number): ()
	local time: number? = playersInputTimers[player]
	if time then
		time = amount
	end
end

function module:getPlayerAFKTime(player): number
	return playersInputTimers[player]
end

return module
