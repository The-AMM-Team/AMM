--<< Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--<< Modules
local Round = require(script.Parent.Round)
local Roles = require(script.Parent.Roles)
local Character = require(script.Parent.Character)

--<< Packages
local Fusion = require(ReplicatedStorage.Shared.Packages.fusion)
local New = Fusion.New

--<< Remotes
local serverNet = require(script.Parent.serverNet)

--<< Private Variables
local playerHitboxs: {[Player]: Part} = {}

--<< Private Functions
local function createHitbox(): Part
    return New "Part" {
        Parent = workspace,
        Color = Color3.fromRGB(255,0 ,0),
        Transparency = 0.75,
        Anchored = true,
        CanCollide = false,
        Size = Vector3.new(3.5, 6, 3.5),
    }
end

local function checkDistance(p1: Vector3, p2: Vector3): number
    return (p1 - p2).Magnitude
end

local function convertTableWithKeysToValues<I, V>(tbl: {[I]: V}): {V}
    local out = {}
    
    for _, value: V in tbl do
        table.insert(out, value)
    end

    return out
end

local function findPlayerFromHitbox(foundHitbox: Part): Player?
    for player: Player, hitbox: Part in playerHitboxs do
         if hitbox == foundHitbox then
            return player
         end
    end
end

local function getHitboxsWithoutAPlayer(player: Player): {[Player]: Part}
    local out = table.clone(playerHitboxs)
    out[player] = nil
    return out
end

--<< Public Variables
local module = {}

--<< Public Functions
function module:Start()

    for _, player: Player in Players:GetPlayers() do
        self:createHitbox(player)
    end

    Players.PlayerAdded:Connect(function(player)
        self:createHitbox(player)
    end)

     serverNet.Attack.On(function(player: Player, Data: {characterCFrame: CFrame, mousePosition: Vector3})
        local character: Model? = player.Character
        
        if character and character.PrimaryPart then
            if checkDistance(Data.characterCFrame.Position, character.PrimaryPart.Position) < 3 then
                local role = Roles:getPlayerRole(player)
                if role == "sheriff" then
                    self:attackWithGun(player, Data.characterCFrame, Data.mousePosition) 
                elseif role == "murderer" then
                    self:attackWithKnife(player, Data.characterCFrame)
                else
                    local _ = self:attackWithGun(player, Data.characterCFrame, Data.mousePosition)
                end
            end
        end
    end)

end

function module:createHitbox(player: Player)

    local character = player.Character or player.CharacterAdded:Wait()

    playerHitboxs[player] = createHitbox()
    RunService.Heartbeat:Connect(function()
        if character then
            self:getHitbox(player).Position = character.PrimaryPart.Position 
        end
    end)

    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
    end)

end

function module:getHitbox(player: Player): Part
    return playerHitboxs[player]
end

function module:attackWithKnife(killer: Player, characterCFrame: CFrame)

    local overlapParams = OverlapParams.new()
    overlapParams.FilterDescendantsInstances = convertTableWithKeysToValues(getHitboxsWithoutAPlayer(killer))
    overlapParams.FilterType = Enum.RaycastFilterType.Include

    local foundBaseParts = workspace:GetPartBoundsInBox(characterCFrame + characterCFrame.LookVector * 4, Vector3.new(4, 4, 4), overlapParams)

    if #foundBaseParts > 0 then
        for _, part: BasePart in foundBaseParts do
            local player = findPlayerFromHitbox(part)
            if player then
                self:killPlayers(killer, {player}) 
                return    
            end
        end
    end

end

function module:attackWithGun(killer: Player, characterCFrame: CFrame, hit: Vector3)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = convertTableWithKeysToValues(getHitboxsWithoutAPlayer(killer))
    raycastParams.FilterType = Enum.RaycastFilterType.Include

    local result = workspace:Raycast(characterCFrame.Position, (hit  - characterCFrame.Position).Unit*300, raycastParams)
    if result then
        local player = findPlayerFromHitbox(result.Instance)
        self:killPlayers(killer, {player}) 
    end
end

function module:killPlayers(killer: Player, playersToKill: {Player})

    for _, player: Player in playersToKill do
        local humanoid: Humanoid? = Character:getPlayersHumanoid(player)
            
        if humanoid then
            humanoid:TakeDamage(100)
        end
    end
    
end

return module