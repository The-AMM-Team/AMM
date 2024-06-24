--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Database = require(script.Parent.Database)
local Chance = require(ReplicatedStorage.Shared.Chance)
local Crates = require(ReplicatedStorage.Shared.Info.Crates)

--<< Remotes
local ServerRemotes = require(ReplicatedStorage.Shared.Remotes.ServerRemotes)
local openCrate = ServerRemotes.OpenCrate
local crateResult = ServerRemotes.CrateResult

--<< Private Variables
local playersCrateCooldowns = {} 

--<< Public Variables
local module = {
    
}

--<< Public Functions
function module:Start()
    
    openCrate.SetCallback(function(player: Player, crateName: string)

        if not self:getPlayerCrateCooldown(player) then
            self:setPlayerCrateCooldown(player, true)
        else
            return    
        end

        local item = self:buyCrate(player, crateName)
    
        crateResult.Fire(player, item)
        task.wait(10)
        self:setPlayerCrateCooldown(player, false)
    end)

end

function module:setPlayerCrateCooldown(player: Player, enabled: boolean)
    playersCrateCooldowns[player] = enabled
end

function module:getPlayerCrateCooldown(player): boolean
    return playersCrateCooldowns[player]
end

function module:buyCrate(player: Player, name: string): string?

    local crate = Crates[name]

    assert(crate, `could not find {name} as a crate!`)

    local cost = crate.cost
    local items = crate.items 

    local playerData = Database:getKeepData(player) 

    if playerData.coins >= cost then
        playerData.coins -= cost
        
        local item = Chance(items)
        return item
    end

    return nil
end