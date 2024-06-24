--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

--<< Remotes
local ServerRemotes = require(ReplicatedStorage.Shared.Remotes.ServerRemotes)
local coins = ServerRemotes.Coins
local coinDestroy = ServerRemotes.CoinDestroy
local coinSpawn = ServerRemotes.CoinSpawn

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
	coinsInArea: fusion.Scope<typeof(fusion)>,
}

--<< Private Variables
local coinAreaScope = scoped(fusion)
local coinAreasInfo = {} :: {[Part]: coinAreaInfo}   

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
	for _, area: Part in mapInfo.coinSpawns:GetChildren() do
		self:createSpawningArea(area)
	end

	spawningThread = task.spawn(function()
		while true do
			task.wait(0.9)

			local areaPart = getRandomArea(mapInfo.coinSpawns:GetChildren())

			local coinAreaInfo = coinAreasInfo[areaPart]

			if #coinAreaInfo.coinsInArea >= coinAreaInfo.maxAmount  then
				task.spawn(function()
					areaPart.Color = Color3.fromRGB(255, 0, 0)	
					areaPart.Transparency = 0
					task.wait(0.5)
					areaPart.Color = Color3.fromRGB(255, 255, 255)
					areaPart.Transparency = 1
				end)
				continue 
			end

			self:spawnCoin(coinAreaInfo,
				areaPart.Position
					+ Vector3.new(
						math.random(-areaPart.Size.X/2, areaPart.Size.X/2),
						1.5,
						math.random(-areaPart.Size.Z/2, areaPart.Size.Z/2)
					)
			)
		end
	end)

end

function module:createSpawningArea(area: Part)
	coinAreasInfo[area] = {
		maxAmount = (area.Size.X * area.Size.Y) * 0.05,
		coinsInArea = coinAreaScope:innerScope()
	}
end

function module:spawnCoin(spawningArea: coinAreaInfo, location: Vector3)
	
	local coinScope = spawningArea.coinsInArea:innerScope()
	spawningArea.maxAmount += 1

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
					else
						block = true
					end
					spawningArea.maxAmount -= 1
					fusion.doCleanup(coinScope)
					coinDestroy.FireAll(uID)

					local keep = Database:getKeep(player)
					if keep then
						keep:addCoins(1)
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
		coinAreasInfo = {}
	end
end

function module:clearAllCoins()
	fusion.doCleanup(coinAreaScope)
end

return module
