--// Ignore the bag coding i rushed it in 10 mins (Made by @kylosilly)
local replicated_storage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local local_player = players.LocalPlayer

lighting.ClockTime = 12
lighting.GlobalShadows = false

local npc = workspace.ServerNPCs.HUNTER
local oven = workspace.Map.EE:FindFirstChild("Oven")
local chocolates = workspace.Map.EE:FindFirstChild("Chocolate")
local electronics = workspace.Map.EventObjects.Electronics

if workspace.Map:GetAttribute("MapName") == "Lodge" and #players:GetPlayers() < 2 then
    local_player:Kick("2 Players Required To Collect This Badge!")
end

if workspace.Map:GetAttribute("MapName") == "Family Home" then
    print("Collecting Egg Badge For Family Home...")
    local_player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
    task.wait(1)
    fireproximityprompt(npc.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt"))
    task.wait(12)
    local_player.Character.HumanoidRootPart.CFrame = oven.PrimaryPart.CFrame
    task.wait(2)
    fireproximityprompt(oven.PrimaryPart:FindFirstChild("CookPrompt"))
    task.wait(2)
    fireproximityprompt(oven.PrimaryPart:FindFirstChild("RemovePrompt"))
    task.wait(2)
    local_player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
    task.wait(2)
    fireproximityprompt(npc.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt"))
    task.wait(14)
    local_player.Character.HumanoidRootPart.CFrame = workspace.Map.EE.Egg.CFrame
    task.wait(2)
    fireproximityprompt(workspace.Map.EE.Egg:FindFirstChildOfClass("ProximityPrompt"))
    print("Egg Badge Collected!")
elseif workspace.Map:GetAttribute("MapName") == "Lodge" and #players:GetPlayers() > 1 then -- youre litteraly forced to be 2 people LMAO
    print("Collecting Egg Badge For Lodge...")
    local_player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
    task.wait(1)
    fireproximityprompt(npc.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt"))
    task.wait(20)
    for _, chocolate in next, chocolates:GetChildren() do
        if chocolate:IsA("Part") then
            local_player.Character.HumanoidRootPart.CFrame = chocolate.CFrame
            task.wait(.25)
            fireproximityprompt(chocolate:FindFirstChildOfClass("ProximityPrompt"))
            task.wait(.5)
        end
    end

    local_player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
    task.wait(2)
    fireproximityprompt(npc.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt"))
    task.wait(5)
    print("Egg Badge Collected!")
elseif workspace.Map:GetAttribute("MapName") == "Village" then
    print("Collecting Egg Badge For Village...")
    local_player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
    task.wait(1)
    fireproximityprompt(npc.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt"))
    task.wait(20)
    for _, tv in next, electronics:GetChildren() do
        if tv:IsA("Model") and tv.Name == "TV" then
            local tv_code = tv.Base.SurfaceGui.TextLabel
            if tv_code.Text then
                replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("EEService"):WaitForChild("RF"):WaitForChild("SubmitEasterCode"):InvokeServer(tv_code.Text)
                break
            end
        end
    end

    task.wait(10)

    local eggs = workspace.Map.EE

    for _, egg in next, eggs:GetChildren() do
        if egg:IsA("MeshPart") then
            local_player.Character.HumanoidRootPart.CFrame = egg.CFrame
            task.wait(.25)
            fireproximityprompt(egg:FindFirstChildOfClass("ProximityPrompt"))
            task.wait(.5)
        end
    end

    print("Egg Badge Collected!")
end
