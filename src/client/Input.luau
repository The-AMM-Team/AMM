--!strict

--<< Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService") 
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)   

--<< Network 
local clientNet = require(script.Parent.clientNet)

local AttackRemote = clientNet.Attack

--<< Types
type device = "Keyboard" | "Phone" | "Controller"?

--<< Public 
local module = {
	_connections = {}
}

--<< Public Functions
function module:Start()

	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) 

		if gameProcessedEvent then return end
		if input.KeyCode and self._connections[input.KeyCode] then
			self._connections[input.KeyCode].signal:Fire()
			self._connections[input.KeyCode].fired += 1
		end
	end)

	local Mouse = Players.LocalPlayer:GetMouse() 
	Mouse.Button1Down:Connect(function()
		local character = Players.LocalPlayer.Character
		
		if character and character.PrimaryPart then
			AttackRemote.Fire({
				characterCFrame = character.PrimaryPart.CFrame, 
				mousePosition = Mouse.Hit.Position
			})			
		end

	end)

end

function module:getAllActiveInputs(): {Enum.KeyCode}
	local out = {}
	
	for input: Enum.KeyCode, _ in self._connections do
		table.insert(out, input)
	end
	
	return out	
end

function module:bindToInput(input: Enum.KeyCode, callback: () -> ()): (...() -> ()) -> ()

	if not self._connections[input]  then
		self._connections[input] = {
			signal = Signal.new(),
			fired = 0,
			amount = 0
		}
	end

	local connection = self._connections[input].signal:Connect(callback)
	self._connections[input].amount += 1

	return function(...: () -> ())

		self._connections[input].amount -= 1
		connection:Disconnect()

		if self._connections[input].amount == 0 then
			self._connections[input].signal:Destroy()
			self._connections[input] = nil
		end

		for _: number, cleanupFunction: () -> () in {...} do
			cleanupFunction()
		end

	end

end

function module:getInputInformation(input: Enum.KeyCode): {amount: number, fired: number, signal: Signal.Signal<nil>}?
	return if self._connections[input] then
		self._connections[input]
		else 
		nil
end

function module:getDevice(): device
	return if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		"Phone"
		elseif UserInputService.KeyboardEnabled then
		"Keyboard"
		elseif UserInputService.GamepadEnabled then
		"Controller"
		else
		-- Default to keyboard
		"Keyboard"
end

function module:isDevice(device: device): boolean
	return self:getDevice() == device
end

function module:isKeyDown(input: Enum.KeyCode): boolean
	return UserInputService:IsKeyDown(input)
end

return module



