if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded")
end

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

library:Notify("Adding a option soon to use modifiers")

local replicated_storage = game:GetService("ReplicatedStorage")
local local_player = game:GetService("Players").LocalPlayer
local Version = "V1.7.0"

library:Notify("Ran Auto Farm Script Current Version: " .. Version)

if local_player then
    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("CreateLobby"):InvokeServer("Auto Farm Made By @kylosilly", 1, 0, "Private")
    library:Notify("Lobby Created")
    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Map", "Cargo")
    library:Notify("Changed Map To Cargo")
    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Difficulty", "Insanity")
    library:Notify("Changed Difficulty To Insanity")

    if local_player:GetAttribute("Prestige") < 1 then
        library:Notify("Starting Game")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptStart"):InvokeServer()
    elseif local_player:GetAttribute("Prestige") > 0 then
        library:Notify("Applying Modifiers")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Depleted", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Marathon", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "WeakLegs", true)
        library:Notify("Starting Game")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptStart"):InvokeServer()
    elseif local_player:GetAttribute("Prestige") > 1 then
        library:Notify("Applying Modifiers")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Depleted", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Marathon", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "WeakLegs", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "BlownFusebox", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "NoHiding", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "NoRecovery", true);
        library:Notify("Starting Game")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptStart"):InvokeServer()
    elseif local_player:GetAttribute("Prestige") > 3 then -- Skipping Prestige 3 because the modifier wont spawn all evidences needed :sob:
        library:Notify("Applying Modifiers")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Depleted", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Marathon", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "WeakLegs", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "BlownFusebox", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "NoHiding", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "NoRecovery", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Countdown", true);
        library:Notify("Starting Game")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptStart"):InvokeServer()
    elseif local_player:GetAttribute("Prestige") > 4 then -- Skipping Total Insanity because its almost the same as prestige 3 perk
        library:Notify("Applying Modifiers")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Depleted", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Marathon", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "WeakLegs", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "BlownFusebox", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "NoHiding", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "NoRecovery", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Countdown", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Bloodlust", true);
        library:Notify("Starting Game")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptStart"):InvokeServer()
    elseif local_player:GetAttribute("Prestige") > 9 then
        library:Notify("Applying Modifiers")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Depleted", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Marathon", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "WeakLegs", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "BlownFusebox", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "NoHiding", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "NoRecovery", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Countdown", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Bloodlust", true); replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Modifier", "Nightmare", true);
        library:Notify("Starting Game")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptStart"):InvokeServer()
    end
end
