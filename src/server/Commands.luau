--<< Services
local Players = game:GetService("Players")

--<< Modules
local Hitboxs = require(script.Parent.Hitboxs)

--<< Private Variables
local systemAdmins = { 5439364582 }

local module = {

	playersWithCommands = {},

	privateRoutes = {
		["/th"] = function()
			Hitboxs:toggleVisibleHitboxs(not Hitboxs:isHitboxShown())
		end,
	},
}

function module:Start()
	for _, player: Player in Players:GetPlayers() do
		self:playerAdded(player)
	end

	Players.PlayerAdded:Connect(function(player: Player)
		self:playerAdded(player)
	end)
end

function module:playerAdded(player: Player)
	if table.find(systemAdmins, player.UserId) then
		player.Chatted:Connect(function(message: string, recipient: Player?)
			self:runPrivateCommand(message)
		end)
	end
end

function module:isPrivateCommand(command: string): boolean
	return if self.privateRoutes[command] then true else false
end

function module:runPrivateCommand(plainCommand: string)
	--// Foramt Command Args
	local args = string.split(string.lower(plainCommand), " ")
	local command = args[1]

	--// Find command
	if self:isPrivateCommand(command) and self.privateRoutes[command] then
		--// Remove first arg (it's the name of the function)
		table.remove(args, 1)

		return self.privateRoutes[command](table.unpack(args))
	end

	return
end

return module
