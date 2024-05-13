--<< Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

--<< Private Functions
local function createSound(id: number): Sound
    local sound = Instance.new("Sound")
    sound.SoundId = `rbxassetid://{id}`
    sound.Parent = SoundService
    sound.Volume = 5
    return sound
end
--<< Global Variables
local module = {}

--<< Global Functions
function module:playLocalSound(id: number): ()
    local sound = createSound(id)
    sound:Play()
    task.wait(sound.TimeLength)
    sound:Destroy()
end

function module:playSoundOnPart(id: number, parent: BasePart): ()
    local sound: Sound = createSound(id)
    sound.Parent = parent
    sound:Play()
    sound.Ended:Wait()
    sound:Destroy()
end

return module