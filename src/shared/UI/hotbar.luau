--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--<< Modules
local Guns = require(ReplicatedStorage.Shared.Info.Guns)
local Knifes = require(ReplicatedStorage.Shared.Info.Knifes)

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = Fusion.scoped

--<< Types
type props = {
	shown: Fusion.UsedAs<boolean>,
	equipped: Fusion.Value<{}, number>,
	role: Fusion.UsedAs<string>,
}

type slotProps = {
	scope: Fusion.Scope<typeof(Fusion)>,
	role: Fusion.UsedAs<string>,
	shown: Fusion.UsedAs<boolean>, 
	slot: number,
	equipped: Fusion.UsedAs<number>,
	activated: () -> ()
}

--<< Private Functions
local function hotbarSlot(props: slotProps)
	
	--// Connections
	local currentTime = props.scope:Value(os.clock())
	table.insert(props.scope, {
		RunService.RenderStepped:Connect(function(_: number)
			currentTime:set(os.clock())
		end),
	})
	
	local rotationValue = props.scope:Value(12)
	local rotationSpring = props.scope:Spring(rotationValue, 25, 0.5)
	
	props.scope:Observer(props.equipped):onChange(function()  
		if props.scope.peek(props.equipped) == props.slot then
			rotationValue:set(2)
		else
			rotationValue:set(12)
		end
	end)

	props.scope:Observer(props.shown):onChange(function()
		if props.scope.peek(props.shown) then
			rotationSpring:addVelocity(360 + 360)
		end
	end)

	return props.scope:New("Frame")({

		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(100, 100),

		[props.scope.Children] = {

			props.scope:New("Frame")({

				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(29, 29, 29),
				BackgroundTransparency = 0.1,
				Position = props.scope:Spring(props.scope:Computed(function(use, scope)  
					return if props.slot == use(props.equipped) then
						UDim2.fromScale(0.5, 0.3)
					else
						UDim2.fromScale(0.5, 0.5)
				end), 25, 0.5),
				Rotation = 25,
				Size = UDim2.fromScale(1, 1),

				[props.scope.Children] = {

					props.scope:New("UICorner")({
						CornerRadius = UDim.new(0.05, 0),
					}),

					props.scope:New("UIStroke")({
						Color = Color3.fromRGB(255,255,255),
						Thickness = 7,
						[props.scope.Children] = {
							props.scope:New "UIGradient" {
								Color = props.scope:Computed(function(use, scope)  
									return if use(props.equipped) == props.slot then
										ColorSequence.new(
											{ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
											ColorSequenceKeypoint.new(0.95, Color3.fromRGB(30, 30, 30)),
											ColorSequenceKeypoint.new(1, Color3.fromHex("ffb030"))
										})
									else
										ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(30, 30, 30))
								end) ,
								Rotation = props.scope:Computed(function(use, scope)  
									return (use(currentTime) * 175) % 360
								end)
							}
						}
					}),

					props.scope:New("ImageButton")({

						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.fromScale(0.5, 0.5),
						Rotation = rotationSpring,
						Size = UDim2.fromScale(2, 2),

						Image = props.scope:Computed(function(use, scope)
							local role = use(props.role)
							return props.scope.Safe({
								try = function()
									if role == "murderer" then
										local knife: Knifes.knife = Knifes["flameDragon"]
										return if knife
											then knife.image
											else error(`Could not find the knife called: {"flameDragon"}`, 1)
									elseif role == "sheriff" then
										local gun: Guns.gun = Guns["lilFlame"] 
										return if gun 
										then gun.image 
										else error(`Could not find the gun called: {"lilFlame"}`, 1)
									else
										return "no role :("
									end
								end,
								fallback = function(err)
									warn(err)
									return "rbxassetid://17704860256"
								end,
						    })
						end),

						[Fusion.OnEvent "Activated"] = function()
							props.activated()
						end

					})
				},
			}),
		},
	})
end

return function(props: props)
	local hotbarScope = scoped(Fusion)

	hotbarScope:New "ScreenGui" {

		Parent = Players.LocalPlayer.PlayerGui,
		IgnoreGuiInset = true,

		[hotbarScope.Children] = {
			hotbarScope:New("Frame")({
				AnchorPoint = hotbarScope:Spring(
					hotbarScope:Computed(function(use, scope)
						return if use(props.shown) then Vector2.new(0.5, 1) else Vector2.new(0.5, 0)
					end),
					30,
					1
				),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.fromScale(1, 0.175),
		
				[hotbarScope.Children] = {
		
					hotbarScope:New("UIListLayout")({
						Padding = UDim.new(0.025, 0),
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
		
					hotbarSlot {
						scope = hotbarScope,
						role = props.role,
						shown = props.shown,
						equipped = props.equipped,
						slot = 1,
						activated = function()
							if 1 == hotbarScope.peek(props.equipped) then
								props.equipped:set(0)
							else
								props.equipped:set(1)
							end
						end
					},

				},
			})
		}

	}
	
end
