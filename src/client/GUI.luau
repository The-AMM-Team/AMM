--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Input = require(script.Parent.Input)
local Camera = require(script.Parent.Camera)
local Background = require(script.Parent.Background)
local Animation = require(script.Parent.Animation)
local ClientState = require(script.Parent.ClientState)

--<< Remotes
local clientNet = require(script.Parent.clientNet)

--<< Packages
local Vide = require(ReplicatedStorage.Shared.Packages.vide)
local source = Vide.source
local effect = Vide.effect
local create = Vide.create
local mount = Vide.mount

--<< Private Functions
local function createScreen(): ScreenGui
	return create("ScreenGui")({
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		Parent = Players.LocalPlayer.PlayerGui,
		Name = "MAIN",
	}) :: ScreenGui
end

--<< Public Variables
local module = {
	screen = createScreen(),
}

--<< Public Functions
function module:Start()
	self:version()
	self:client()
	--self:hotbar()

	-- testing stuff
	Input:bindToInput(Enum.KeyCode.E, function()
		local unmount = Background:createBackground({
			damping = 0.75,
			time = 0.5,
			backgroundColor3 = Color3.fromRGB(25, 25, 25),
			transparency = 0.25,
			cleanup = function()	
				print("I've ended")
			end,
		})
		Camera:setCameraFieldOfView(50)
		task.wait(0.5)
		unmount()
		Camera:setCameraFieldOfView(75)
	end)

	local equipped = source(false)
	local animation: () -> ()

	mount(function()
		effect(function()
			if not ClientState.round() and equipped() then
				animation()
				equipped(false)
			end
		end)
	end)

	Input:bindToInput(Enum.KeyCode.One, function()
		if equipped() then
			animation()
			clientNet.Unequip.Fire()
		else
			animation = Animation:playAnimationOnPlayer(16882019560)
			clientNet.Equip.Fire()
		end
		equipped(not equipped())
	end)
end

-- Binded Inputs module?
-- function module:hotbar()

--     local animation: () -> ()? = nil

--     local equipped = Value(false)
--     Observer(equipped):onChange(function()
--         if not equipped:get() and animation then
--             animation()
--         end
--     end)

--     Observer(ClientState.round):onChange(function()
--         if not ClientState.round:get() then
--             equipped:set(false)
--             clientNet.Unequip.Fire()
--         end
--     end)

--     Input:bindToInput(Enum.KeyCode.One, function()
--         local currentlyInRound = ClientState.round:get()
--         local currentRole =  ClientState.currentRole:get()

--         if not currentlyInRound or currentRole == "innocent" then return end

--         if equipped:get() then
--             clientNet.Unequip.Fire()
--         else
--             if currentRole == "sheriff" then
--                 animation = Animation:playAnimationOnPlayer(17224465048)
--             else
--                 animation = Animation:playAnimationOnPlayer(16882019560)
--             end

--             clientNet.Equip.Fire()
--         end
--         equipped:set(not equipped:get())

--     end)

-- end

function module:version()
	local versionUI = require(ReplicatedStorage.Shared.UI.version)

	local version: string = require(ReplicatedStorage.Shared.Info.Version)
	local device: ("Controller" | "Keyboard" | "Phone")? = Input:getDevice()

	if device == "Phone" then
		mount(function()
			return versionUI({
				version = version,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
			})
		end, self.screen)
	else
		mount(function()
			return versionUI({
				version = version,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
			})
		end, self.screen)
	end
end

function module:client()
	local clientUI = require(ReplicatedStorage.Shared.UI.client)

	clientUI({
		parent = self.screen,
	})
end

function module:crateOpening()

	-- local openCrate = require(script.Parent.UI.openCrate)

	-- ClientState.crateResult:Connect(function(item: string)
	--     mount(function()
	--         return openCrate(item)
	--     end, self.screen)
	-- end)
end

return module
