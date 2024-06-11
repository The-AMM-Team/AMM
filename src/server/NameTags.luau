--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Database = require(script.Parent.Database)
local Character = require(ReplicatedStorage.Shared.Character)
local nameTag = require(ReplicatedStorage.Shared.UI.nameTag)

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = Fusion.scoped

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

--<< Private Variables
local playerNameTagScope = scoped(Fusion) 
local playerNameTags = {}

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()

	Database.onDataLoaded:Connect(function(player: Player, data: Types.playerData)  
		Character:bindCallbackToCharacter(player, function(_: Model?)  
			self:connectToCharactercreateNameTag(player, data)
		end)
	end)

end

function module:connectToCharactercreateNameTag(player: Player, data: Types.playerData): ()
	local head: BasePart? = Character:getBodyPartFromCharacter(player, "Head")
	if head then
		playerNameTags[player] = nameTag(playerNameTagScope, {
			head = head,
			player = player,
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
