--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Modules
local Roles = require(script.Parent.Roles)
local Map = require(script.Parent.Map)

--<< Utils

--<< Packages
local Signal = require(ReplicatedStorage.Shared.Packages.lemonsignal)

--<< Remotes

--<< Types

--<< Private Variables
local intermissionTime = 1
local roundTime = 1

local playersInRound = {}
local playersInLobby = {}

--<< Private Functions
local function checkIfCharactersAreLoaded(players: {Player}): {Player}
    local out = {}
    for _, player in players do
        local character: Model? = player.Character
        if character then
            local humanoid: Humanoid? = character:FindFirstChild("Humanoid") :: Humanoid
            if humanoid then
                table.insert(out, player)
            end
        end
    end
    return out
end

--<< Public Variables
local module = {

    --// Signals
    endIntermission = Signal.new(),
    endRound = Signal.new(),

    onIntermissionStart = Signal.new(),
    onRoundStart = Signal.new(),
    
    onPlayerAddedToLobby = Signal.new(),
    onPlayerAddedToRound = Signal.new(),
    
    onPlayerRemovingFromLobby = Signal.new(),
    onPlayerRemovingFromRound = Signal.new(),

    toggleDebug = Signal.new(),

}

--<< Public Functions
function module:Start(): ()

    for _, player: Player in Players:GetPlayers() do
        self:playerAdded(player)
    end

    Players.PlayerAdded:Connect(function(player)
        self:playerAdded(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        self:playerDeathOrRemoving(player)
		self:removeFromLobby({player})
    end)

    --[[
        Debug
    ]]
    do 
        self.toggleDebug:Connect(function(toggle: boolean)
            print(`Turning Debug mode to {toggle}`)
        end)
    end

    self:startIntermission()

end

--[[
    Handles people joining
]]
function module:playerAdded(player: Player)
    
    --// gottas check if the got caught 2 times
    if not self:isPlayerInLobby(player) and not self:isPlayerInRound(player) then
        self:addPlayersToLobby({player})
        
        player.CharacterAdded:Connect(function(character)
            local humanoid: Humanoid? = character:FindFirstChild("Humanoid") :: Humanoid

            if humanoid then
                
                if humanoid:GetState() == Enum.HumanoidStateType.Dead then
                    self:playerDeathOrRemoving(player)
                    return 
                end

                humanoid.Died:Connect(function()
                    self:playerDeathOrRemoving(player)
                end)

            end

        end)

    end

end

--[[
    Gives players in round
]]
function module:getPlayersInRound(): {Player}
    return playersInRound
end

--[[
    Gives players in lobby
]]
function module:getPlayersInLobby(): {Player}
    return playersInLobby
end

--[[
    Adds players to round
]]
function module:addPlayersToRound(players: {Player}): ()
    for _, player: Player in players do
        table.insert(playersInRound, player)
        self.onPlayerAddedToRound:Fire(player)
    end
end

--[[
    Adds players to lobby
]]
function module:addPlayersToLobby(players: {Player}): ()
    for _, player: Player in players do
        table.insert(playersInLobby, player)
        self.onPlayerAddedToLobby:Fire(player)
    end
end

--[[
    Removes players from round
]]
function module:removeFromRound(players: {Player}, teleportBack: boolean?): ()
    
    for _, player in players do
        
        local index = table.find(playersInRound, player)

        if index then
            table.remove(playersInRound, index)
            self.onPlayerRemovingFromRound:Fire(player)
            if teleportBack then
                local character: Model? = player.Character
                
                if character then
                    character:PivotTo(CFrame.new(0, 10, 0))
                end

            end

        end

    end

end

--[[
    Removes players from lobby
]]
function module:removeFromLobby(players: {Player}): ()
    
    for _, player in players do
        
        local index = table.find(playersInLobby, player)

        if index then
            table.remove(playersInLobby, index)
            self.onPlayerRemovingFromLobby:Fire(player)
        end

    end

end

--[[
    Checks if the player is in the round
]]
function module:isPlayerInRound(player: Player): boolean
    return if table.find(playersInRound, player) then true else false
end

--[[
    Checks if the player is in the round
]]
function module:isPlayerInLobby(player: Player): boolean
    return if table.find(playersInLobby, player) then true else false
end

--[[
    Checks if a new round can start
]]
function module:checkIfRoundCanStart(): {Player}?
    
    if #Players:GetPlayers() >= 2 then
        
        local loaded_players = checkIfCharactersAreLoaded(playersInLobby) 

        if #loaded_players >= 2 then
            return loaded_players
        end

    end

    return nil

end

--[[    
    Checks if round can end
]]
function module:checkIfRoundCanEnd()
    
    -- Switch on roles

end

--[[
    Checks on the dead player or leaving player
]]
function module:playerDeathOrRemoving(player: Player)
    if self:isPlayerInRound(player) then
        
        self:removeFromRound({player})
        self:addPlayersToLobby({player})

        self:checkIfRoundCanEnd()
    end
end

--[[
    Cleans up round stuff this crap is so confusing 
]]
function module:roundCleanup(): ()
    
    local playersInCurrentRound = table.clone(self:getPlayersInRound())

    self:removeFromRound(playersInCurrentRound, true)
    self:addPlayersToLobby(playersInCurrentRound)
    Roles:resetAllRoles()
    Map:unloadMap()

end

--[[
    Some flash effects because this a party not a drugstore
]]
function module:roundEndingEffects()
    
    --// you should add some sounds here but I ain't doin all that

end

--[[
    Main bloodflow of the code... if this junk breakl everything breaks
]]
function module:startIntermission(reason: string?): ()
    
    --// why is reason here, good question I have no freaking idea
    if reason then
        print(reason)
    end

    self.onIntermissionStart:Fire()

    --// some thread stuff
    local thread: thread? = nil

    --// checks if someone skiped intermission
    local connection = self.endIntermission:Connect(function()
        
        --// cap that ***** *** thread (I pray every night that this doesn't mem leak)
        coroutine.close(thread)

        --// start a new round : ))
        local playersReadyToGoIntoRound: {Player}? = self:checkIfRoundCanStart()
        if playersReadyToGoIntoRound then
            self:startRound(playersReadyToGoIntoRound)
        else
            self:startIntermission("Need more players to start")
        end

    end)

    thread = coroutine.create(function()
        
        --// timer
        for _ = intermissionTime, 1, -1 do
            task.wait(1)
        end

        connection:Disconnect()
        
        --// start a new round : ))
        local playersReadyToGoIntoRound: {Player}? = self:checkIfRoundCanStart()
        if playersReadyToGoIntoRound then
            self:startRound(playersReadyToGoIntoRound)
        else
            self:startIntermission("Need more players to start")
        end 

    end)

    --// I was thinking, coroutine sounds so like western like (koooruuthing) OOOO maybe kinda like dexxter (KORUTHIN YA KNOW)
    coroutine.resume(thread)

end

--[[
    Again main bloodflow of the code
]]
function module:startRound(players: {Player}): ()

    --// Add players to the round table and off lobby table
    self:removeFromLobby(players)
    self:addPlayersToRound(players)

    --// generate some roles : - )
    Roles:generateRoles(players)

    --// send this info to the client b*tch
    Map:loadMap(players)

    self.onRoundStart:Fire()

    --// thread stuff
    local thread: thread? = nil 

    --// so many things could go wrong with a marriage just like this code (I am signing divorce papers soon)
    local connection = self.endRound:Connect(function(reason: string)
        
        --// gun down the thread with a aka47 (.close function is the aka47)
        coroutine.close(thread)

        self:roundEndingEffects()
        self:roundCleanup()
        self:startIntermission(reason)

    end)

    thread = coroutine.create(function()
        
        --// Round timer
        for _ = roundTime, 1, -1 do
            task.wait(1)
        end

        --// Disconnect this because yes
        connection:Disconnect()

        self:roundEndingEffects()
        self:roundCleanup()
        self:startIntermission("Innocents Won")

    end)

    --// start running the round :0
    coroutine.resume(thread)

end

return module