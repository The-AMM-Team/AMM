--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Server
local Round = require(script.Round)
local Roles = require(script.Roles)
local Database = require(script.Database)
local Weapon = require(script.Weapon)
local Items = require(script.Items)

Database:Start()
Round:Start()
Roles:Start()
Weapon:Start()
Items:Start()

-- Shared
local Character = require(ReplicatedStorage.Shared.Character)

Character:Start()