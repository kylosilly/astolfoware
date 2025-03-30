if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded")
end

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

library:Notify("Adding a option soon to use modifiers")

local replicated_storage = game:GetService("ReplicatedStorage")
local local_player = game:GetService("Players").LocalPlayer

if local_player then
    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("CreateLobby"):InvokeServer("Auto Farm Made By @kylosilly", 1, 0, "Private")
    library:Notify("Lobby Created")
    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Map", "Cargo")
    library:Notify("Changed Map To Cargo")
    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Difficulty", "Insanity")
    library:Notify("Changed Difficulty To Insanity and Started Game")
    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptStart"):InvokeServer()
else
    local_player:Kick("Kicked (REPORT THIS TO @kylosilly ON DISCORD)")
end
