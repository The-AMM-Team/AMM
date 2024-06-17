--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local GlobalUIState = require(ReplicatedStorage.Shared.Info.GlobalUIState)

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local Children = fusion.Children
local scope = fusion.scoped
local peek = fusion.peek
local OnEvent = fusion.OnEvent

--<< Types
type settingOption = {
	name: string,
	desc: string,
	callback: (on: boolean) -> (),
	defaultValue: boolean,
}

--<< Private Functions
local function createToggleButton(
	scope: fusion.Scope<typeof(fusion)>,
	defaultValue: boolean,
	callback: (on: boolean) -> ()
): fusion.Child
	local heldDown = scope:Value(false)

	local on = scope:Value(defaultValue)
	scope:Observer(on):onChange(function()
		callback(peek(on))
	end)

	local onColorSpring = scope:Spring(
		scope:Computed(function(use, scope)
			return if use(on) then Color3.fromRGB(0, 255, 119) else Color3.fromRGB(255, 66, 69)
		end),
		25,
		0.6
	)

	return scope:New("Frame")({

		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(15, 15, 15),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.75, 0.75),

		[Children] = {
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.2, 0),
			}),

			scope:New("ImageButton")({
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = scope:Spring(
					scope:Computed(function(use, scope)
						return if use(on) then UDim2.fromScale(0.75, 0.5) else UDim2.fromScale(0.25, 0.5)
					end),
					25,
					0.6
				),
				Size = scope:Spring(
					scope:Computed(function(use, scope)
						return if use(heldDown) then UDim2.fromScale(0.404, 0.845) else UDim2.fromScale(0.519, 1.086)
					end),
					25,
					1
				),
				Image = "rbxassetid://1512913149",
				ImageColor3 = onColorSpring,

				[OnEvent("MouseButton1Down")] = function()
					heldDown:set(true)
				end,

				[OnEvent("MouseButton1Up")] = function()
					heldDown:set(false)
				end,

				[OnEvent("MouseLeave")] = function()
					heldDown:set(false)
				end,

				[OnEvent("Activated")] = function()
					on:set(not peek(on))
				end,

				[Children] = scope:New("Frame")({
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = onColorSpring,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.6, 0.6),
					[Children] = scope:New("UICorner")({
						CornerRadius = UDim.new(0.2, 0),
					}),
				}),
			}),
		},
	})
end

local function createSettingsOptionUI(
	scope: fusion.Scope<typeof(fusion)>,
	index: number,
	settingsOptionInfo: settingOption
)
	local settingOptionScope = scope:innerScope()
	local frameSizeValue = scope:Value(UDim2.fromScale(0.25, 0.125))

	settingOptionScope:Observer(GlobalUIState.currentOpenedMenu):onChange(function()
		if peek(GlobalUIState.currentOpenedMenu) then
			frameSizeValue:set(UDim2.fromScale(0.975, 0.125))
		else
			frameSizeValue:set(UDim2.fromScale(0.25, 0.125))
		end
	end)

	return settingOptionScope:New("Frame")({

		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Name = string.upper(settingsOptionInfo.name),
		Size = settingOptionScope:Spring(frameSizeValue, 15 - index / 10, 0.675),

		LayoutOrder = index,

		[Children] = {

			settingOptionScope:New("UICorner")({
				CornerRadius = UDim.new(0.1, 0),
			}),

			settingOptionScope:New("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			settingOptionScope:New("UIStroke")({
				Color = Color3.fromRGB(45, 45, 45),
				Thickness = 3,
			}),

			settingOptionScope:New("Frame")({
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.65, 1),

				[Children] = {

					settingOptionScope:New("UIPadding")({
						PaddingBottom = UDim.new(0.1, 0),
						PaddingLeft = UDim.new(0.04, 0),
					}),

					settingOptionScope:New("TextLabel")({
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.35),
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 0.5),

						FontFace = Font.fromEnum(Enum.Font.GothamBold),
						Text = settingsOptionInfo.name,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextXAlignment = Enum.TextXAlignment.Left,
					}),

					settingOptionScope:New("TextLabel")({
						AnchorPoint = Vector2.new(0, 1),
						BackgroundTransparency = 1,
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.fromScale(1, 0.25),

						FontFace = Font.fromEnum(Enum.Font.GothamBold),
						Text = settingsOptionInfo.desc,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextTransparency = 0.5,
						TextXAlignment = Enum.TextXAlignment.Left,
					}),
				},
			}),
			settingOptionScope:New("Frame")({
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.35, 1),
				[Children] = createToggleButton(
					settingOptionScope,
					settingsOptionInfo.defaultValue,
					settingsOptionInfo.callback
				),
			}),
		},
	})
end

return function(settings: { settingOption })
	local settingsScope = scope(fusion)
	local frameVisible = settingsScope:Value(false)

	settingsScope:Observer(GlobalUIState.currentOpenedMenu):onChange(function()
		if peek(GlobalUIState.currentOpenedMenu) then
			frameVisible:set(true)
		else
			frameVisible:set(false)
		end
	end)

	settingsScope:New("ScreenGui")({

		Parent = Players.LocalPlayer.PlayerGui,
		IgnoreGuiInset = true,

		[Children] = settingsScope:New("Frame")({

			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(35, 35, 35),
			Position = UDim2.fromScale(0.5, 0.55),
			Size = settingsScope:Spring(
				settingsScope:Computed(function(use, scope)
					return if use(GlobalUIState.currentOpenedMenu) == "settings"
						then UDim2.fromScale(0.3, 0.55)
						else UDim2.fromScale(0, 0)
				end),
				25,
				0.6
			),
			Visible = frameVisible,

			[Children] = {
				settingsScope:New("UIAspectRatioConstraint")({
					AspectRatio = 0.809,
				}),
				settingsScope:New("UICorner")({
					CornerRadius = UDim.new(0.025, 0),
				}),
				settingsScope:New("UIStroke")({
					Color = Color3.fromRGB(57, 57, 57),
					Thickness = 7,
				}),
				settingsScope:New("TextLabel")({

					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, -0.2),
					Size = UDim2.fromScale(0.65, 0.15),

					FontFace = Font.fromEnum(Enum.Font.GothamBold),
					Text = "Settings",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,

					[Children] = settingsScope:New("UIStroke")({
						Thickness = 5,
					}),
				}),
				settingsScope:New("ScrollingFrame")({
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.9, 0.95),
					CanvasSize = UDim2.fromScale(0.5, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarImageTransparency = 1,
					ScrollBarThickness = 0,
					[Children] = {
						settingsScope:New("Frame")({
							Size = UDim2.fromScale(1, 0.005),
							BackgroundTransparency = 1,
						}),
						settingsScope:New("UIListLayout")({
							Padding = UDim.new(0.05, 0),
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
						}),
						settingsScope:ForPairs(settings, function(ues, scope, key: number, info: settingOption)
							return key, createSettingsOptionUI(scope, key, info)
						end),
					},
				}),
			},
		}),
	})
end
