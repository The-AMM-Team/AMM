--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Input = require(script.Input)
local Camera = require(script.Camera)
local Round = require(script.Round)
local Load = require(script.Load)
local Hotbar = require(script.Hotbar)
local Attack = require(script.Attack)

local Sound = require(ReplicatedStorage.Shared.Sound)

--<< Start Modules

Load:Start()
Round:Start()
Input:Start()
Camera:Start()
Hotbar:Start()
Attack:Start()
Sound:Start()