local ReplicatedStorage = game:GetService("ReplicatedStorage")
--<< Services

--<< Modules

--<< Remotes
local clientNet = require(script.Parent.clientNet)

--<< Packages
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = Fusion.scoped
local peek = Fusion.peek

--<< Types
type module = {
	round: Fusion.UsedAs<boolean>,
	currentRole: Fusion.UsedAs<string?>,
	crateResult: Signal.Signal<string>,

	Start: (self: module) -> (),
}

--<< Private Variables
local clientStateScope = scoped(Fusion)

--<< Public Variables
local module: module = {

	round = clientStateScope:Value(false),
	currentRole = clientStateScope:Value(nil),

	crateResult = Signal.new(),
} :: module


--<< Public Functions
function module:Start()

	clientNet.Round.SetCallback(function(roundInProgress: boolean)
		self.round:set(roundInProgress)
		if not peek(self.round) then
			self.currentRole:set(nil)
		end
	end)
	
	clientNet.Role.SetCallback(function(role: string)
		self.currentRole:set(role)
	end)

	clientNet.CrateResult.SetCallback(function(item: string)
		self.crateResult:Fire(item)
	end)
end

return module
