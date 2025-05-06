
local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

local replicated_storage = cloneref(game:GetService("ReplicatedStorage"))
local http_service = cloneref(game:GetService("HttpService"))
local workspace = cloneref(game:GetService("Workspace"))
local players = cloneref(game:GetService("Players"))
local local_player = players.LocalPlayer

local guid = http_service:GenerateGUID(false)

if game.PlaceId == 123410273444568 then
    if getfenv().settings.dupe_method ~= 1 then
        library:Notify("Only 1 Method Exist For This Game!")
        return
    end

    library:Notify("Starting Dupe...")

    local collectables = workspace:FindFirstChild(local_player.Name .. "_Hatch")
    if collectables then
        for _, v in next, collectables:GetChildren() do
            if v:IsA("Model") and v.PrimaryPart and v.PrimaryPart:FindFirstChildOfClass("ProximityPrompt") then
                if (local_player.Character:GetPivot().Position - v:GetPivot().Position).Magnitude < 5 then
                    for i = 1, getfenv().settings.dupe_amount do
                        fireproximityprompt(v.PrimaryPart:FindFirstChildOfClass("ProximityPrompt"))
                    end
                end
            end
        end
        library:Notify("Done Duping")
    end
elseif game.PlaceId == 89726090098716 then
    if getfenv().settings.dupe_method ~= 1 then
        library:Notify("Only 1 Method Exist For This Game!")
        return
    end

    library:Notify("Starting Dupe...")

    local_player.Character.HumanoidRootPart.Anchored = true

    for i = 1, getfenv().settings.dupe_amount do
        replicated_storage:WaitForChild("Postie"):WaitForChild("Sent"):FireServer("PlantEgg", guid, workspace:WaitForChild("Plots"):WaitForChild(local_player.Name.."_Plot"):WaitForChild(local_player.Name.."_Soil"), local_player.Character:GetPivot().Position - Vector3.new(0, 4.5, 0), "DragonTowerEgg")
    end
    local_player.Character.HumanoidRootPart.Anchored = false
    library:Notify("Done Duping")
else
    library:Notify("Unsupported Game!")
end
