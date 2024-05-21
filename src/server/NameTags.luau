--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Database = require(script.Parent.Database)
local Character = require(ReplicatedStorage.Shared.Character)
local nameTag = require(ReplicatedStorage.Shared.UI.nameTag)

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

--<< Private Variables
local playerNameTags = {}

--<< Global Variables
local module = {}

--<< Global Functions
function module:Start()

	Database.onDataLoaded:Connect(function(player: Player, data: Types.playerData)  
		Character:bindCallbackToCharacter(player, function(_: Model?)  
			self:connectToCharactercreateNameTag(player, data)
		end)
	end)

end

function module:connectToCharactercreateNameTag(player: Player, data: Types.playerData): ()
	local character: Model? = player.Character
	if character then
		playerNameTags[player] = nameTag({
			head = Character:getBodyPartFromCharacter(player, "Head"),
			playerName = player.DisplayName,
			roles = data.roles,
		})
	end
end

function module:destoryNameTag(player: Player): ()
	if self:playerHasNameTag(player) then
		playerNameTags[player]:Destroy()
	end
end

function module:playerHasNameTag(player: Player): boolean
	return if playerNameTags[player] then true else false
end

return module
