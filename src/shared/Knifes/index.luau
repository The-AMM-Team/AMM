--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return {

    ["default"] = {

        displayName = "Default Knife",
        image = "",
        model = workspace,
    
        canDelete = false, 
        raitity = "common",
    
    },

    ["flameDragon"] = {
        displayName = "Flame Dragon",
        image = "",
        model = ReplicatedStorage.Models.Knifes.flameDragon,
    
        canDelete = true, 
        raitity = "legendary",
    }

}