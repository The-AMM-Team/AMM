--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Input = require(script.Input)
local Camera = require(script.Camera)
local Sound = require(ReplicatedStorage.Shared.Sound)
local Round = require(script.Round)

--<< Pre Loading
Sound:loadAllSounds()

--<< Start Modules
Round:Start()
Input:Start()
Camera:Start()
