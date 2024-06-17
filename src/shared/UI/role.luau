--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Role = require(ReplicatedStorage.Shared.Info.Colors.Role)
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local Sound = require(ReplicatedStorage.Shared.Sound)
local Children = fusion.Children

--<< Types
type props = {
	role: string,
}

return function(scope: fusion.Scope<typeof(fusion)>, props: props)
	local sizeValue = scope:Value(UDim2.fromScale(0.4, 0.15))

	local titleVisible = scope:Value(false)
	local titleWords = scope:Value("")
	local titleRotation = scope:Spring(0, 20, 0.5)

	local roleText = scope:Value("")
	local roleSize = scope:Value(UDim2.fromScale(1, 0.2))
	local roleTextColor = scope:Value(Color3.fromRGB(255, 255, 255))

	scope:New("ScreenGui")({

		Parent = Players.LocalPlayer.PlayerGui,
		IgnoreGuiInset = true,

		[Children] = {
			scope:New("Frame")({

				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0.05),
				Size = scope:Spring(sizeValue, 25, 0.65),

				[Children] = {

					scope:New("TextLabel")({

						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0),
						Rotation = titleRotation,
						Position = UDim2.fromScale(0.5, 0),
						Size = UDim2.fromScale(1, 0.2),

						Visible = titleVisible,

						Text = titleWords,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						FontFace = Font.fromEnum(Enum.Font.GothamBold),
						TextScaled = true,
						[Children] = {
							scope:New("UIStroke")({
								Thickness = 3,
							}),
						},
					}),

					scope:New("TextLabel")({

						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = scope:Spring(roleSize, 25, 0.5),

						Visible = titleVisible,

						Text = roleText,
						TextColor3 = scope:Spring(roleTextColor, 25, 0.5),
						FontFace = Font.fromEnum(Enum.Font.GothamBold),
						TextScaled = true,
						[Children] = {
							scope:New("UIStroke")({
								Thickness = 3,
							}),
						},
					}),
				},
			}),
		},
	})

	table.insert(
		scope,
		task.spawn(function()
			task.wait(0.5)
			titleVisible:set(true)
			titleWords:set("You")
			Sound:playSound("kick boom 1", {
				async = true,
				group = "SFX",
				volume = 1,
			})
			titleRotation:addVelocity(25)
			task.wait(1)
			titleWords:set("You Are")
			Sound:playSound("kick boom 1", {
				async = true,
				group = "SFX",
				volume = 1,
			})
			titleRotation:addVelocity(25)
			task.wait(0.75)
			roleText:set(".")
			Sound:playSound("click 1", {
				async = true,
				group = "SFX",
				volume = 0.75,
			})
			task.wait(0.5)
			roleText:set(". .")
			Sound:playSound("click 1", {
				async = true,
				group = "SFX",
				volume = 0.75,
			})
			task.wait(0.5)
			roleText:set(". . .")
			Sound:playSound("click 1", {
				async = true,
				group = "SFX",
				volume = 0.75,
			})
			task.wait(0.5)
			roleText:set(string.upper(props.role))
			roleTextColor:set(Role[props.role])
			roleSize:set(UDim2.fromScale(1, 0.4))
			Sound:playSound("yay", {
				async = true,
				group = "SFX",
				volume = 1,
			})
			task.wait(6)
			sizeValue:set(UDim2.fromScale(0, 0))
			task.wait(1)
			fusion.doCleanup(scope)
		end)
	)

	return function()
		fusion.doCleanup(scope)
	end
end
