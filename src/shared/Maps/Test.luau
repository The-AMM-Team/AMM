--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--<< Types
local Types = require(ReplicatedStorage.Shared.Types)

return {

    name = "Test",
    spawns = workspace.Test.Spawns,
    
    components = {

        {
            load = function()
                warn("Component system has been loaded")
            end,

            unload = function()
                warn("Component system has been unloaded")
            end
        }

    }

} :: {

    name: string,
    spawns: Folder,
    components: {Types.component}

}
