--<< Modules
local Database = require(script.Database)
local Round = require(script.Round)
local Roles = require(script.Roles)
local Weapon = require(script.Weapon)
local Hitboxs = require(script.Hitboxs)
local Commands = require(script.Commands)
local Items = require(script.Items)
local Afk = require(script.Afk)

--<< Start Module
Database:Start()
Round:Start()
Roles:Start()
Weapon:Start()
Hitboxs:Start()
Commands:Start()
Items:Start()
Afk:Start()

