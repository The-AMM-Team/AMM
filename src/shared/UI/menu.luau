--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local GlobalUIState = require(ReplicatedStorage.Shared.Info.GlobalUIState)
local Sound = require(ReplicatedStorage.Shared.Sound)

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = fusion.scoped

--<< Private Function
local function createButton(scope: fusion.Scope<typeof(fusion)>, name: string, image: string)
	local sizeValue = scope:Value(UDim2.fromScale(1.5, 1.5))
	local sizeSpring = scope:Spring(sizeValue, 25, 0.5)

	return scope:New("Frame")({

		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0.521, 0.185),

		[scope.Children] = {

			scope:New("ImageButton")({

				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = sizeSpring,

				Image = image,

				[scope.OnEvent("MouseEnter")] = function()
					sizeValue:set(UDim2.fromScale(1.4, 1.4))
				end,

				[scope.OnEvent("MouseLeave")] = function()
					sizeValue:set(UDim2.fromScale(1.5, 1.5))
				end,

				[scope.OnEvent("Activated")] = function()
					sizeSpring:addVelocity(-UDim2.fromScale(0.25, 0.25))
					if scope.peek(GlobalUIState.currentOpenedMenu) == name then
						GlobalUIState.currentOpenedMenu:set(nil)
					else
						GlobalUIState.currentOpenedMenu:set(name)
					end
					Sound:playSoundOnClient("UI Click 1", {
						group = "SFX",
					})
				end,

				[scope.Children] = scope:New("TextLabel")({
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.8),
					Size = UDim2.fromScale(1, 0.3),

					FontFace = Font.fromEnum(Enum.Font.MontserratBold),
					Text = name,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,

					[scope.Children] = scope:New("UIStroke")({
						Thickness = 5,
					}),
				}),
			}),
		},
	})
end

return function()
	local menu = scoped(fusion)

	menu:New("ScreenGui")({

		Parent = Players.LocalPlayer.PlayerGui,
		IgnoreGuiInset = true,

		[menu.Children] = menu:New("Frame")({

			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,

			Size = UDim2.fromScale(0.1, 0.5),
			Position = UDim2.fromScale(0, 0.5),

			[menu.Children] = {

				menu:New("UIListLayout")({
					Padding = UDim.new(0.05, 0),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),

				createButton(menu, "Shop", "rbxassetid://18197547405"),
				createButton(menu, "Inventory", "rbxassetid://18197588822"),
				createButton(menu, "Settings", "rbxassetid://18197597504"),
			},
		}),
	})

	return function()
		fusion.doCleanup(menu)
	end
end
