--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--<< Packages
local Datakeep = require(ReplicatedStorage.Shared.ServerPackages.datakeep)
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)

--<< Private Variables
local template = {
    
    coins = 0,
    
    joinDate = os.time(),

}

local KeepStore = Datakeep.GetStore(if RunService:IsStudio() then "TEMP" else "MAIN", template):expect()

local loadedKeeps = {}

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

--<< Public Variables
local module = {
    
    onDataLoaded = Signal.new(),

}

--<< Public Functions
function module:Start()

    for _, player: Player in Players:GetPlayers() do
        self:playerAdded(player)
    end

    Players.PlayerAdded:Connect(function(player)
        self:playerAdded(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        local keep = self:getKeep(player)

        if keep then
           keep:Release() 
        end
    end)

end

function module:playerAdded(player: Player)
    
    KeepStore:LoadKeep(`PLAYER_{player.UserId}`):andThen(function(keep)
        
        if not keep then
            player:Kick("Data Couldn't load :/")
        end

        keep.Releasing:Connect(function(state)
            state:andThen(function()
                print(`{player.Name} is releasing keep!`)
                player:Kick("Session Release")
            end):catch(function(err)
                warn(`player failed to releasse {player.Name} keep!`, err)
            end)
        end)

        if not player:IsDescendantOf(Players) then
            keep:Release()
            return
        end

        loadedKeeps[player] = keep
        keep.Data.coins = 1000
        self.onDataLoaded:Fire(keep.Data)

    end)

end

function module:getPlayerData(player: Player): Types.playerData
    return self:getKeep(player).Data
end

function module:getKeep(player: Player): any?
    return loadedKeeps[player]
end

return module