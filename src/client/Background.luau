--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--<< Packages
local Vide = require(ReplicatedStorage.Shared.Packages.vide)

local source = Vide.source
local mount = Vide.mount
local create = Vide.create
local spring = Vide.spring
local cleanup = Vide.cleanup

--<< Types
type backgroundProps = {
	transparency: number,
	backgroundColor3: Color3,
	time: number,
	damping: number,
	cleanup: () -> (),
}

--<< Private Variables
local screen = create("ScreenGui")({
	Parent = Players.LocalPlayer.PlayerGui,
	Name = "Backgrounds",
	IgnoreGuiInset = true,
})

--<< Public Variables
local module = {}

--<< Public Functions
function module:createBackground(props: backgroundProps): () -> ()
	local backgroundTransparencySource = source(1)

	local out = mount(function()
		backgroundTransparencySource(props.transparency)

		local out = create("Frame")({
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = props.backgroundColor3,
			BackgroundTransparency = spring(backgroundTransparencySource, props.time, props.damping),
		})

		cleanup(function()
			out:Destroy()
			if props.cleanup then
				props.cleanup()
			end
		end)

		return out
	end, screen)

	return out
end

return module
