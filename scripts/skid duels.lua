if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

local replicated_storage = game:GetService('ReplicatedStorage')
local tween_service = game:GetService('TweenService')
local run_service = game:GetService('RunService')
local workspace = game:GetService('Workspace')
local players = game:GetService('Players')
local local_player = players.LocalPlayer
local camera = workspace.CurrentCamera

function check_loaded(v)
    if not v or v == local_player then return end
    if not v:HasAppearanceLoaded() then
        repeat task.wait(.25) print("Waiting For: "..v.Name) until v:HasAppearanceLoaded()
    end
end

for _,v in next, players:GetPlayers() do
    check_loaded(v)
end

players.PlayerAdded:Connect(function(v)
    check_loaded(v)
end)

task.wait(6)

replicated_storage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("Auto Farm V1.0.0 Made By @kylosilly", "All")

if local_player.TeamColor == BrickColor.new("Bright red") then
    library:Notify("Starting Auto Farm!")
    while true do
        local connections; connections = run_service.Heartbeat:Connect(function()
            if local_player.Character.HumanoidRootPart then
                local_player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                local_player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end)
        if local_player.PlayerGui.Hotbar.MainFrame.GameEndFrame.Visible then
            replicated_storage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("gg :3", "All")
            library:Notify("Game Ended, Teleporting To Next Match...")
            connections:Disconnect()
            replicated_storage:WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("MatchService"):WaitForChild("RF"):WaitForChild("EnterQueue"):InvokeServer("Solo")
            return
        end
        local blue_finish = workspace.Map.BlueBase.Goal
        local distance = (blue_finish.Position - local_player.Character.HumanoidRootPart.Position).magnitude
        local tween = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new(distance / 25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = CFrame.new(blue_finish.Position)})
        tween:Play()
        tween.Completed:Wait()
        task.wait(5)
    end
elseif local_player.TeamColor == BrickColor.new("Bright blue") then
    library:Notify("Starting Auto Farm!")
    while true do
        local connections; connections = run_service.Heartbeat:Connect(function()
            if local_player.Character.HumanoidRootPart then
                local_player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                local_player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end)
        if local_player.PlayerGui.Hotbar.MainFrame.GameEndFrame.Visible then
            replicated_storage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("gg :3", "All")
            library:Notify("Game Ended, Teleporting To Next Match...")
            connections:Disconnect()
            replicated_storage:WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("MatchService"):WaitForChild("RF"):WaitForChild("EnterQueue"):InvokeServer("Solo")
            return
        end
        local red_finish = workspace.Map.RedBase.Goal
        local distance = (red_finish.Position - local_player.Character.HumanoidRootPart.Position).magnitude
        local tween = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new(distance / 25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = CFrame.new(red_finish.Position)})
        tween:Play()
        tween.Completed:Wait()     
        task.wait(5)
    end
end
