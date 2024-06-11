--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Database = require(script.Parent.Database)
local Round = require(script.Parent.Round)
local Character = require(ReplicatedStorage.Shared.Character)
local Knifes = require(ReplicatedStorage.Shared.Info.Knifes)
local Guns = require(ReplicatedStorage.Shared.Info.Guns)

--<< Remotes
local serverNet = require(script.Parent.serverNet)

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = Fusion.scoped

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

type playerItemInfo = {
	cooldown: boolean,
	mountedItems: {},
}

--<< Private Variables
local playersItemScope = scoped(Fusion) 
local playersItemInfomation: { [Player]: playerItemInfo } = {}

--<< Private Functions
local function deepLookup(tbl: { [string]: any }, ...: string): any?
	local out: { [string]: any } = tbl
	for _, index: string in { ... } do
		local value = out[index]
		if value then
			out = value
		else
			return nil
		end
	end
	return out
end

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start(): ()

	for player: Player, _ in Database:getAllPlayersKeeps() do
		local data = Database:getPlayerData(player)
		
		playersItemInfomation[player] = {
			cooldown = false,
			mountedItems = {},
		}

		--<< Mounts the players knifes and gun on side
		Character:bindCallbackToCharacter(player, function(_: Model?)
			-- if data then
			-- 	self:mountItemToPlayer(player, data.currentKnife.name, "LowerTorso", "RootRigAttachment")
			-- 	self:mountItemToPlayer(player, data.currentGun.name, "LowerTorso", "RootRigAttachment")
			-- end
		end)

	end

	Database.onDataLoaded:Connect(function(player: Player, data: Types.playerData)
		playersItemInfomation[player] = {
			cooldown = false,
			mountedItems = {},
		}

		Character:bindCallbackToCharacter(player, function(_: Model?)
			-- if data then
			-- 	self:mountItemToPlayer(player, data.currentKnife.name, "LowerTorso", "RootRigAttachment", true)
			-- 	self:mountItemToPlayer(player, data.currentGun.name, "LowerTorso", "RootRigAttachment", true)
			-- end
		end)
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		playersItemInfomation[player] = nil
	end)

	Round.onIntermissionStart:Connect(function() end)

	--// So basically I am lost myself but this mounts the knife/Gun in hand and unmounts it from hip
	serverNet.Equip.SetCallback(function(player: Player)
		self:mountItemToPlayer(player, "flameDragon", "RightHand", "RightGripAttachment")
	end)

	serverNet.Unequip.SetCallback(function(player: Player)
		self:unmountItemFromPlayer(player, "RightHand", "flameDragon")
	end)
end

function module:mountItemToPlayer(
	player: Player,
	item: string,
	bodyPartName: string,
	attachmentPoint: string,
	offset: boolean?
): ()
	local playerCurrentMountedItems = playersItemInfomation[player].mountedItems
	local info: Guns.gun? | Knifes.knife? = Guns[item] or Knifes[item]

	assert(info, `Could not find the item named: {item}`)
	assert(info.model, `Could not find the model in: {item}`)

	if not playerCurrentMountedItems[bodyPartName] then
		playerCurrentMountedItems[bodyPartName] = {}
	end

	if playerCurrentMountedItems[bodyPartName][item] then
		warn("You have to unequip item before calling equip!")
		return
	end

	local bodypart: BasePart? = Character:getBodyPartFromCharacter(player, bodyPartName)

	if bodypart then
		local bodyPartAttachment: Attachment = bodypart:FindFirstChild(attachmentPoint) :: Attachment

		playerCurrentMountedItems[bodyPartName][item] = playersItemScope:Hydrate(info.model:Clone())({
			Parent = bodypart,
		})

		playersItemScope:New("Weld")({
			Parent = playerCurrentMountedItems[bodyPartName][item],
			C0 = playerCurrentMountedItems[bodyPartName][item]:FindFirstChild(attachmentPoint).CFrame
				+ if offset then info.offset else Vector3.new(),
			C1 = bodyPartAttachment.CFrame,
			Part0 = playerCurrentMountedItems[bodyPartName][item],
			Part1 = bodypart,
		})
	end
end

function module:unmountItemFromPlayer(player: Player, bodypart: string, item: string): ()
	local info = playersItemInfomation[player]
	local foundItem: Instance? = deepLookup(info.mountedItems, bodypart, item)
	if foundItem then
		foundItem:Destroy()
		info.mountedItems[bodypart][item] = nil
	end
end

return module
