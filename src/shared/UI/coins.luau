local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local Children = fusion.Children
local scoped = fusion.scoped

local short = {"", "K", "M", "B", "T"} --

local function formatNumbers(amount: number): string?
	local str = tostring(math.floor(amount))
	return string.sub(str, 1, ((#str+2)%3) + 1)..short[math.floor((#str-1)/3) + 1]
end

return function(coinAmountValue: fusion.UsedAs<number>, hide: fusion.UsedAs<boolean>): () -> ()
	
	local coinScope = scoped(fusion)

	local sizeSpring = coinScope:Spring(UDim2.fromScale(0.394, 1.97), 25, 0.5)
	local positionSpring = coinScope:Spring(UDim2.fromScale(0.625, 0.5), 25, 0.5)

	coinScope:Observer(coinAmountValue):onChange(function()
		sizeSpring:addVelocity(UDim2.fromScale(0.4, 2))
		positionSpring:addVelocity(UDim2.fromScale(0.1, 0.5))
	end)

	coinScope:New "ScreenGui" {
		
		Name = "Coins",
		IgnoreGuiInset = true,
		Parent = Players.LocalPlayer.PlayerGui,
	
		[Children] = {

			coinScope:New("Frame")({

				BackgroundTransparency = 1,
				AnchorPoint = coinScope:Spring(coinScope:Computed(function(use, scope)
					return if use(hide) then 
						Vector2.new(1, 0.5)
					else
						Vector2.new(0, 0.5)
				end), 25, 0.5),
				Size = UDim2.fromScale(0.15, 0.045),
				Position = UDim2.fromScale(0, 0.675),
		
				[Children] = {
		
					coinScope:New("TextLabel")({
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = UDim2.fromScale(0.5, 1),
						Position = positionSpring,
						Text = coinScope:Computed(function(use, scope)
							return if use(coinAmountValue) then
								formatNumbers(use(coinAmountValue))
							else
								"loading..."
						end),
						TextColor3 = Color3.fromHex("ffe394"),
						FontFace = Font.fromEnum(Enum.Font.GothamBold),
						TextScaled = true,
		
						[Children] = {
							coinScope:New("UIStroke")({
								Thickness = 3,
							}),
						},
					}),
		
					coinScope:New("ImageLabel")({
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = sizeSpring,
						Position = UDim2.fromScale(0.2, 0.5),
		
						Image = "rbxassetid://17647073855",
						ScaleType = Enum.ScaleType.Crop,
					}),
				},

			})

		}

	}

end
