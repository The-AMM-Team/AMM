local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Input = require(script.Input)
local Camera = require(script.Camera)
local Sound = require(ReplicatedStorage.Shared.Sound)
local Round = require(script.Round)

Sound:loadAllSounds()

Round:Start()
Input:Start()
Camera:Start()
