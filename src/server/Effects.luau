--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules

--<< Remotes

--<< Packages
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal) 
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local scoped = Fusion.scoped

--<< Types
type effectGroupInfo = {
	scope: Fusion.Scope<typeof(Fusion)>,
	folder: Folder,
	endAllEffects: Signal.Signal<nil>,
}

type settings = {
	destoryDelay: number,
}

--<< Private Variables
local effectScope = scoped(Fusion) 
local effectGroups = {}

--<< Private Functions

--<< Public Variables
local module = {}

--<< Public Functions
function module:createEffectGroup(name: string): effectGroupInfo
	if effectGroups[name] then return effectGroups[name] end
	local scope = effectScope:innerScope() 
	effectGroups[name] = {
		scope = scope,
		folder = scope:New "Folder" {
			Parent = workspace,
			Name = name
		},
		endAllEffects = Signal.new(),
	}
	return effectGroups[name]
end

function module:getEffectGroup(name: string): effectGroupInfo?
	return effectGroups[name]
end

function module:gunTrail(group: string, orgin: Vector3, hit: Vector3, settings: settings)

	local groupInfo: effectGroupInfo = self:getEffectGroup(group) or self:createEffectGroup(group)

	local trailScope = groupInfo.scope:innerScope()

	local partTransparency = trailScope:Value(0.8)
	local partTransparencyTween = trailScope:Tween(partTransparency, TweenInfo.new(1, Enum.EasingStyle.Linear))

	trailScope:New("Part")({
		Parent = groupInfo.folder,
		Size = Vector3.new(0.1, 0.1, (orgin - hit).Magnitude),
		Transparency = partTransparencyTween,
		Anchored = true,
		CanCollide = false,
		CFrame = CFrame.lookAt(orgin, hit) * CFrame.new(0, 0, -(orgin - hit).Magnitude / 2),
	})

	partTransparency:set(1)

	table.insert(trailScope, groupInfo.endAllEffects:Once(function(...: any)  
		Fusion.doCleanup(trailScope)
	end))

	table.insert(trailScope, task.delay(settings.destoryDelay, function()
		Fusion.doCleanup(trailScope)
	end))

end

return module
