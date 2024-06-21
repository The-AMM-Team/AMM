--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local coins = require(ReplicatedStorage.Shared.UI.coins)

--<< Remotes
local clientNet = require(script.Parent.clientNet)
local Coins = clientNet.Coins
local CoinSpawn = clientNet.CoinSpawn
local CoinDestroy = clientNet.CoinDestroy

--<< Modules
local Sound = require(ReplicatedStorage.Shared.Sound)

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = fusion.scoped
local peek = fusion.peek

--<< Types

--<< Private Variables
local coinsScope = scoped(fusion)
local coinAmount = fusion.Value({}, nil)
local hide = fusion.Value({}, true)

local potatoMode = fusion.Value({}, false)

--<< Private Functions

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
	CoinSpawn.SetCallback(function(coinData: { position: { number }, uuid: string })
		local coinModelScope = coinsScope:innerScope()

		local spawningPosition = Vector3.new(coinData.position[1], coinData.position[2], coinData.position[3])

		local rotation = coinModelScope:Value(Vector3.new(0, 0, -90))
		local position = coinModelScope:Value(spawningPosition)

		local positionTween = coinModelScope:Tween(
			position,
			TweenInfo.new(3, Enum.EasingStyle.Quint, Enum.EasingDirection.In, -1, true)
		)

		local rotationTween = coinModelScope:Tween(
			rotation,
			TweenInfo.new(4.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
		)

		local coinModel: BasePart = coinModelScope:Hydrate(ReplicatedStorage.Models.Coin:Clone())({
			Parent = workspace,
			CanCollide = false,
			Position = positionTween,
			Rotation = rotationTween,
		}) :: BasePart

		if not peek(potatoMode) then
			rotation:set(Vector3.new(0, 360, -90))
			position:set(spawningPosition - Vector3.new(0, 0.5, 0))				
		end

		table.insert(
			coinModelScope,
			CoinDestroy.On(function(coinUID: string)
				if coinUID == coinData.uuid then
		
					local temp = coinModelScope:New("Part")({
						Parent = workspace,
						CanCollide = false,
						Size = Vector3.new(1, 1, 1),
						Transparency = 1,
						Position = coinModel.Position,
					})

					coinModel:Destroy()

					Sound:playSound("Coin Collect", {
						group = "SFX",
						volume = 0.5,
						parent = temp,
					})

					fusion.doCleanup(coinModelScope)
				end
			end)
		)
	end)

	Coins.SetCallback(function(amount: number)
		coinAmount:set(amount)
	end)

	coins(coinAmount, hide)
end

function module:setPotatoMode(on: boolean)
	potatoMode:set(on)
end

function module:clearAllCoins()
	fusion.doCleanup(coinsScope)
end

function module:hide(on: boolean)
	hide:set(on)
end

function module:getCoins(): number?
	return peek(coinAmount)
end

return module

