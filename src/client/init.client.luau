local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientState = require(script.ClientState)
local Input = require(script.Input)
local Camera = require(script.Camera)
local Sound = require(ReplicatedStorage.Shared.Sound) 

Sound:loadAllSounds()

ClientState:Start()
Input:Start()
Camera:Start()
