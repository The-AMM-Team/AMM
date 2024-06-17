--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Input = require(script.Input)
local Camera = require(script.Camera)
local Round = require(script.Round)
local Settings = require(script.Settings)
local Load = require(script.Load)

--<< Start Modules
Load:Start(false)
Settings:Start()
Round:Start()
Input:Start()
Camera:Start()
