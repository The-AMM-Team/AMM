local ReplicatedStorage = game:GetService("ReplicatedStorage")
--<< Services

--<< Modules

--<< Remotes
local clientNet = require(script.Parent.clientNet)

--<< Packages
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)
local Vide = require(ReplicatedStorage.Shared.Packages.vide)
local source = Vide.source

--<< Types
type module = {
	round: Vide.Source<boolean>,
	currentRole: Vide.Source<string?>,
	crateResult: Signal.Signal<string>,

	Start: (self: module) -> (),
}

--<< Public Variables
local module: module = {

	round = source(false),
	currentRole = source(nil),

	crateResult = Signal.new(),
} :: module


--<< Public Functions
function module:Start()
	clientNet.Round.SetCallback(function(roundInProgress: boolean)
		self.round(roundInProgress)
		if not self.round() then
			self.currentRole(nil)
		end
	end)
	
	clientNet.Role.SetCallback(function(role: string)
		self.currentRole(role)
	end)

	clientNet.CrateResult.SetCallback(function(item: string)
		self.crateResult:Fire(item)
	end)
end

return module
