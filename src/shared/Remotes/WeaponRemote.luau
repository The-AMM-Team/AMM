--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Packages
local Red = require(ReplicatedStorage.Shared.Packages.Red)

--<< Public Functions
return {

    ["Attack"] = Red.Event("Attack", function(characterCFrame: CFrame, mouseHit: CFrame): string
        if typeof(characterCFrame) == "CFrame" and typeof(mouseHit) == "CFrame" then
            return characterCFrame, mouseHit        
        else
            error(`Wrong Types: Got {type(characterCFrame)} : {type(mouseHit)}`, 2)
        end
    end)

}