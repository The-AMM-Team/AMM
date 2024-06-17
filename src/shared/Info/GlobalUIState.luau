--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = fusion.scoped

--<< Private Variables
local globalStateScope = scoped(fusion)

return {

	currentOpenedMenu = globalStateScope:Value(nil),
}
