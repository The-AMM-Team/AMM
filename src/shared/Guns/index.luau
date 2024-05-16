--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return {

    ["default"] = {

        displayName = "Default Gun",
        image = "",
        model = ReplicatedStorage.Models.Guns.default,
    
        canDelete = false, 
        raitity = "common",
    
    },

    ["lilFlame"] = {
        displayName = "lil flame",
        image = "",
        model = ReplicatedStorage.Models.Guns.lilflame,
    
        canDelete = true, 
        raitity = "legendary",
    }

}