--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--<< Modules
local Character = require(ReplicatedStorage.Shared.Character)
local Round = require(script.Parent.Round)
local Animation = require(script.Parent.Animation)
local Input = require(script.Parent.Input)

local KnifeConfig = require(ReplicatedStorage.Shared.Info.KnifeConfig)
local GunConfig = require(ReplicatedStorage.Shared.Info.GunConfig)

local knifes = require(ReplicatedStorage.Shared.Info.Knifes)
local guns = require(ReplicatedStorage.Shared.Info.Guns)

--<< Remotes
local ClientRemotes = require(ReplicatedStorage.Shared.Remotes.ClientRemotes)
local AttackRemote = ClientRemotes.Attack

--<< Private Functions
local cooldown = false

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()
	local mouse = Players.LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function() 
		if Round:getRole() == "sheriff" then
			self:fireGun()
		elseif Round:getRole() == "murderer" then
			self:swingKnife()
		end
	end)
end

function module:swingKnife()
	if not self:getCooldown() and Character:isHumanoidAlive(Players.LocalPlayer) then
		local Mouse = Players.LocalPlayer:GetMouse()
		local humanRootPart: BasePart? = Character:getBodyPartFromCharacter(Players.LocalPlayer, "HumanoidRootPart")
		if humanRootPart then
			Animation:playAnimationOnPlayer("knifeSwing1")
			self:setCooldown(true)
			AttackRemote.Fire({
				characterCFrame = humanRootPart.CFrame,
				mousePosition = Mouse.Hit.Position,
			})
			task.wait(KnifeConfig.swingCooldown)
			self:setCooldown(false)
		end
	end
end

function module:throwKnife()

end

function module:fireGun()
	if not self:getCooldown() and Character:isHumanoidAlive(Players.LocalPlayer) then
		local Mouse = Players.LocalPlayer:GetMouse()
		local humanRootPart: BasePart? = Character:getBodyPartFromCharacter(Players.LocalPlayer, "HumanoidRootPart")
		if humanRootPart then
			self:setCooldown(true)
			AttackRemote.Fire({
				characterCFrame = humanRootPart.CFrame,
				mousePosition = Mouse.Hit.Position,
			})
		end
		task.wait(GunConfig.shootingCooldown)
		self:setCooldown(false)
	end
end

function module:setCooldown(toggle: boolean)
	self.cooldown = toggle
end

function module:getCooldown(): boolean
	return self.cooldown
end

return module
