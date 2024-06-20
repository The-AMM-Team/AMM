--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

--<< Remotes
local serverNet = require(script.Parent.serverNet)
local coins = serverNet.Coins
local coinDestroy = serverNet.CoinDestroy
local coinSpawn = serverNet.CoinSpawn

--<< Modules
local Map = require(script.Parent.Map)
local Database = require(script.Parent.Database)

local Character = require(ReplicatedStorage.Shared.Character)
local Chance = require(ReplicatedStorage.Shared.Chance)

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = fusion.scoped

--<< Types
type coinAreaInfo = {
	maxAmount: number,
	coinsInArea: { Part },
}

--<< Private Variables
local allCoinScope = scoped(fusion)

local spawningThread = nil

--<< Private Functions
local function getRandomArea(areas: { Part }): Part
	local areaChanceTable: { [Part]: number } = {}
	for _, part: Part in areas do
		assert(part:IsA("Part"), "area found was not a part!")
		areaChanceTable[part] = part.Size.X * part.Size.Z
	end

	return Chance(areaChanceTable)
end

local module = {}

function module:spawnInCurrentMap()
	local mapInfo = Map:getCurrentMap()

	spawningThread = task.spawn(function()
		while true do
			task.wait(0.5)
			local areaPart = getRandomArea(mapInfo.spawns:GetChildren())
			self:spawnCoin(
				areaPart.Position
					+ Vector3.new(
						math.random(-areaPart.Size.X, areaPart.Size.X),
						1,
						math.random(-areaPart.Size.Z, areaPart.Size.Z)
					)
			)
		end
	end)
end

function module:spawnCoin(location: Vector3)
	local coinScope = allCoinScope:innerScope()

	local uID = HttpService:GenerateGUID(false)

	coinSpawn.FireAll({
		position = { location.X, location.Y, location.Z },
		uuid = uID,
	})

	local block = false
	table.insert(
		coinScope,
		RunService.Heartbeat:Connect(function(_: number)
			for _, player: Player in Players:GetPlayers() do
				local rootPart: BasePart? = Character:getBodyPartFromCharacter(player, "HumanoidRootPart")
				if rootPart and (location - rootPart.Position).Magnitude < 3 then
					if block then
						return
					end
					block = true
					fusion.doCleanup(coinScope)
					coinDestroy.FireAll(uID)
					local keep = Database:getKeep(player)
					if keep then
						keep:addCoins(math.random(1, 3))
						coins.Fire(player, keep.Data.coins)
					end
				end
			end
		end)
	)
end

function module:stopSpawningCoins()
	if spawningThread then
		task.cancel(spawningThread)
	end
end

function module:clearAllCoins()
	fusion.doCleanup(allCoinScope)
end

return module
