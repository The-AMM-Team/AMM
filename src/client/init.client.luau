local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientState = require(script.ClientState)
local GUI = require(script.GUI)
local Input = require(script.Input)
local Camera = require(script.Camera)

local Sound = require(ReplicatedStorage.Shared.Sound) 

Sound:loadAllSounds()

ClientState:Start()
GUI:Start()
Input:Start()
Camera:Start()
