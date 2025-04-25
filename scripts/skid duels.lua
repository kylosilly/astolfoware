if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

local replicated_storage = game:GetService('ReplicatedStorage')
local local_player = game:GetService('Players').LocalPlayer
local tween_service = game:GetService('TweenService')
local run_service = game:GetService('RunService')
local workspace = game:GetService('Workspace')
local camera = workspace.CurrentCamera

task.wait(5)

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
            library:Notify("Game Ended, Teleporting To Next Match...")
            velocity_connection:Disconnect()
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
            library:Notify("Game Ended, Teleporting To Next Match...")
            velocity_connection:Disconnect()
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
