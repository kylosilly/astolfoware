--// Ik im not the best at optimizations and coding but enjoy <3
local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local Library = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BLibrary%5D'))()
local ThemeManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BThemeManager%5D'))()
local SaveManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BSaveManager%5D'))()

local Window = Library:CreateWindow({
    Title = 'Astolfo Ware',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

--// Tabs

local Tabs = {
    Main = Window:AddTab('Main'),
    Esp = Window:AddTab('Esp'),
    World = Window:AddTab('World'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

--// GroupBoxes

local game_group = Tabs.Main:AddLeftGroupbox('Game Settings')
local player_group = Tabs.Main:AddRightGroupbox('Player Settings')
local ghost_esp_group = Tabs.Esp:AddLeftGroupbox('Ghost Esp Settings')
local item_esp_group = Tabs.Esp:AddRightGroupbox('Item Esp Settings')
local player_esp_group = Tabs.Esp:AddLeftGroupbox('Player Esp Settings')
local EMF_esp_group = Tabs.Esp:AddRightGroupbox('EMF Esp Settings')
local closet_esp_group = Tabs.Esp:AddLeftGroupbox('Closet Esp Settings')
local equipment_esp_group = Tabs.Esp:AddRightGroupbox('Dropped Equipment Esp Settings')
local world_group = Tabs.World:AddLeftGroupbox('World Settings')
local menu_group = Tabs['UI Settings']:AddLeftGroupbox('Menu')
local credits_group = Tabs['UI Settings']:AddRightGroupbox('Credits')

--// Services

local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(game.PlaceId)
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Stats = game:GetService("Stats")
local Cam = Workspace.CurrentCamera

--// Variables

local no_hold_delay = false
local anti_touch = false
local sprint_change = false
local noclip = false
local third_person = false
local inf_jump = false
local show_ghost = false
local highlight_ghost = false
local ghost_name = false
local cursed_object_name = false
local cursed_object_highlight = false
local bone_name = false
local bone_highlight = false
local inf_stamina = false
local jump_enabled = false
local full_bright = false
local emf_name = false
local ambient_changer = false
local player_name = false
local player_highlight = false
local closet_name = false
local closet_highlight = false
local equipment_name = false
local equipment_highlight = false

local touch_distance = 7
local sprint_speed = 1
local GhostRoom = nil

local Device = LocalPlayer:GetAttribute("Device")
local GID = LocalPlayer:GetAttribute("GID")
local Join = LocalPlayer:GetAttribute("Join")

--// Paths

local cursed_objects = Workspace.Map:FindFirstChild("cursed_object")
local ghost_entity = Workspace.NPCs
local Orb = Workspace.Dynamic.Evidence.Orbs
local Fingerprints = Workspace.Dynamic.Evidence.Fingerprints
local EMF = Workspace.Dynamic.Evidence.EMF
local Van = Workspace.Van
local Closets = Workspace.Map.Closets
local Bone = Workspace.Map
local MotionGrid = Workspace.Dynamic.Evidence.MotionGrids
local FuseBox = Workspace.Map.Fusebox.Fusebox
local Rooms = Workspace.Map.Rooms
local dropped_equipment = Workspace.Equipment

--// Main Script

print("Dont worry this info isnt gonna harm you in anyways that your seeings its just for debugging!")
print("Device: " .. Device)
print("LocalPlayer GID: " .. GID)
print("Join Time: " .. os.date("%Y-%m-%d %H:%M:%S", Join))

function InfStamina()
    LocalPlayer:SetAttribute("Stamina", 100)
end

function ChangeSprintSpeed()
    LocalPlayer:SetAttribute("Speed", sprint_speed)
end

local EMFFiveLabel = game_group:AddLabel('EMF 5: Not Found')
local FingerprintsLabel = game_group:AddLabel('Fingerprint: Not Found')
local OrbLabel = game_group:AddLabel('Orbs: Not Found')
local EMFLabel = game_group:AddLabel('Last Seen EMF: None')
local MotionLabel = game_group:AddLabel('Motion: Not Found')
local FreezeLabel = game_group:AddLabel('Freezing: Not Found')
local GhostRoomLabel = game_group:AddLabel('Current Ghost Room: Not Found')

EMF.ChildAdded:Connect(function(child)
    if child:IsA("Part") then
        EMFLabel:SetText("Last Seen EMF: " .. child.Name)
    end
end)

EMF.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "EMF5" then
        EMFFiveLabel:SetText("EMF 5: Yes")
    end
end)

Orb.ChildAdded:Connect(function(child)
    if child:IsA("Part") then
        OrbLabel:SetText("Orbs: Yes")
    end
end)

Fingerprints.ChildAdded:Connect(function(child)
    if child:IsA("Part") then
        FingerprintsLabel:SetText("Fingerprint: Yes")
    end
end)

function CheckMotion()
    for i, v in pairs(MotionGrid:GetDescendants()) do
        if v:IsA("Part") then
            if v.Color == Color3.fromRGB(252, 52, 52) then
                MotionLabel:SetText("Motion: Yes")
            elseif v.BrickColor == BrickColor.new("Toothpaste") then
                MotionLabel:SetText("Motion: No")
            end
        end
    end
end

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if no_hold_delay then
        prompt.HoldDuration = 0
    end
end)

UserInputService.JumpRequest:Connect(function()
    if jump_enabled then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

function ShowGhost()
    for i, v in next, ghost_entity:GetChildren() do
        if v and v:IsA("Model") then
            local body = v:FindFirstChild("Base")
            if body then
                body.Transparency = 0
            end
        end
    end
end

function HighlightGhost()
    for i, v in next, ghost_entity:GetChildren() do
        if v:IsA("Model") and not v:FindFirstChild("Highlight") then
            local Highlight = Instance.new("Highlight")
            Highlight.Parent = v
            Highlight.FillColor = highlight_color
            Highlight.OutlineColor = highlight_color
        end
    end
end

function GhostName()
    for i, v in next, ghost_entity:GetChildren() do
        if v and v:IsA("Model") and not v:FindFirstChild("Esp BillBoard") then
            local BillboardGui = Instance.new("BillboardGui")
            local TextLabel = Instance.new("TextLabel")

            BillboardGui.Parent = v
            BillboardGui.Name = "Esp BillBoard"
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 5, 0)

            TextLabel.Parent = BillboardGui
            TextLabel.Name = "Name Esp"
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Text = "Ghost [" .. v.Name .. "]"
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.Font = "SourceSansBold"
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

function CursedObjectName()
    for i, v in next, cursed_objects:GetChildren() do
        if (v:IsA("MeshPart") or v:IsA("Model")) and not v:FindFirstChild("Esp BillBoard") then
            local BillboardGui = Instance.new("BillboardGui")
            local TextLabel = Instance.new("TextLabel")

            BillboardGui.Parent = v
            BillboardGui.Name = "Esp BillBoard"
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 2, 0)

            TextLabel.Parent = BillboardGui
            TextLabel.Name = "Name Esp"
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Text = v.Name
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.Font = "SourceSansBold"
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

function CursedObjectHighlight()
    for i, v in next, cursed_objects:GetChildren() do
        if (v:IsA("MeshPart") or v:IsA("Model")) and not v:FindFirstChild("Highlight") then
            local Highlight = Instance.new("Highlight")
            Highlight.Parent = v
            Highlight.FillColor = cursed_object_highlight_color
            Highlight.OutlineColor = cursed_object_highlight_color
        end
    end
end

function BoneName()
    for i, v in next, Bone:GetChildren() do
        if v:IsA("MeshPart") and v.Name == "Bone" and not v:FindFirstChild("Esp BillBoard") then
            local BillboardGui = Instance.new("BillboardGui")
            local TextLabel = Instance.new("TextLabel")

            BillboardGui.Parent = v
            BillboardGui.Name = "Esp BillBoard"
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 2, 0)

            TextLabel.Parent = BillboardGui
            TextLabel.Name = "Name Esp"
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Text = v.Name
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.Font = "SourceSansBold"
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

function BoneHighlight()
    for i, v in next, Bone:GetChildren() do
        if v:IsA("MeshPart") and v.Name == "Bone" and not v:FindFirstChild("Highlight") then
            local Highlight = Instance.new("Highlight")
            Highlight.Parent = v
            Highlight.FillColor = bone_highlight_color
            Highlight.OutlineColor = bone_highlight_color
        end
    end
end

function CheckEMFS()
    for i, v in next, EMF:GetChildren() do
        if v:IsA("Part") and emf_name and not v:FindFirstChild("Esp BillBoard") then
            local BillboardGui = Instance.new("BillboardGui")
            local TextLabel = Instance.new("TextLabel")
    
            BillboardGui.Parent = v
            BillboardGui.Name = "Esp BillBoard"
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 0, 0)
    
            TextLabel.Parent = BillboardGui
            TextLabel.Name = "Name Esp"
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Text = v.Name
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.Font = "SourceSansBold"
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

function PlayerName()
    for i, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
            local Humanoid = v.Character:FindFirstChild("Humanoid")
            
            if Humanoid.Health <= 0 then
                if v.Character.Head:FindFirstChild("Esp BillBoard") then
                    v.Character.Head:FindFirstChild("Esp BillBoard"):Destroy()
                end
            elseif player_name and not v.Character.Head:FindFirstChild("Esp BillBoard") then
                local BillboardGui = Instance.new("BillboardGui")
                local TextLabel = Instance.new("TextLabel")
    
                BillboardGui.Parent = v.Character.Head
                BillboardGui.Name = "Esp BillBoard"
                BillboardGui.AlwaysOnTop = true
                BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                BillboardGui.StudsOffset = Vector3.new(0, 5, 0)
    
                TextLabel.Parent = BillboardGui
                TextLabel.Name = "Name Esp"
                TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                TextLabel.Text = v.DisplayName
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextSize = 14
                TextLabel.Font = "SourceSansBold"
                TextLabel.BackgroundTransparency = 1
                TextLabel.TextStrokeTransparency = 0
                TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end
end

function PlayerHighlight()
    for i, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
            local Humanoid = v.Character:FindFirstChild("Humanoid")

            if Humanoid.Health <= 0 then
                if v.Character:FindFirstChild("Highlight") then
                    v.Character:FindFirstChild("Highlight"):Destroy()
                end
            elseif not v.Character:FindFirstChild("Highlight") then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = v.Character
                Highlight.FillColor = player_highlight_color
                Highlight.OutlineColor = player_highlight_color
            end
        end
    end
end

function ClosetName()
    for i, v in next, Closets:GetChildren() do
        if v:IsA("Model") and not v:FindFirstChild("Esp BillBoard") then
            local BillboardGui = Instance.new("BillboardGui")
            local TextLabel = Instance.new("TextLabel")
    
            BillboardGui.Parent = v
            BillboardGui.Name = "Esp BillBoard"
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 5, 0)
    
            TextLabel.Parent = BillboardGui
            TextLabel.Name = "Name Esp"
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Text = v.Name
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.Font = "SourceSansBold"
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

function ClosetHighlight()
    for i, v in next, Closets:GetChildren() do
        if v:IsA("Model") and not v:FindFirstChild("Highlight") then
            local Highlight = Instance.new("Highlight")
            Highlight.Parent = v
            Highlight.FillColor = closet_highlight_color
            Highlight.OutlineColor = closet_highlight_color
        end
    end
end

function EquipmentName()
    for i, v in next, dropped_equipment:GetChildren() do
        if v:IsA("Model") and not v:FindFirstChild("Esp BillBoard") then
            local BillboardGui = Instance.new("BillboardGui")
            local TextLabel = Instance.new("TextLabel")
    
            BillboardGui.Parent = v
            BillboardGui.Name = "Esp BillBoard"
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
    
            TextLabel.Parent = BillboardGui
            TextLabel.Name = "Name Esp"
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Text = v.Name
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.Font = "SourceSansBold"
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

function EquipmentHighlight()
    for i, v in next, dropped_equipment:GetChildren() do
        if v:IsA("Model") and not v:FindFirstChild("Highlight") then
            local Highlight = Instance.new("Highlight")
            Highlight.Parent = v
            Highlight.FillColor = equipment_highlight_color
            Highlight.OutlineColor = equipment_highlight_color
        end
    end
end

function NoClip()
    LocalPlayer.Character.HumanoidRootPart.CanCollide = false
    LocalPlayer.Character.UpperTorso.CanCollide = false
    LocalPlayer.Character.LowerTorso.CanCollide = false
    LocalPlayer.Character.Head.CanCollide = false
end

function PreventTouch()
    for i, v in pairs(ghost_entity:GetChildren()) do
        if v:IsA("Model") then
            local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude
            if Distance < touch_distance then
                LocalPlayer.Character.HumanoidRootPart.CFrame = Van.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                Library:Notify("Ghost was too close teleported to save place.")
            end
        end
    end
end

local Connections = RunService.RenderStepped:Connect(function()
    if inf_stamina then
        InfStamina()
    end

    if sprint_change then
        ChangeSprintSpeed()
    end

    if show_ghost then
        ShowGhost()
    end

    if highlight_ghost then
        HighlightGhost()
    end

    if ghost_name then
        GhostName()
    end

    if anti_touch then
        PreventTouch()
    end

    if cursed_object_name then
        CursedObjectName()
    end

    if cursed_object_highlight then
        CursedObjectHighlight()
    end

    if bone_name then
        BoneName()
    end

    if bone_highlight then
        BoneHighlight()
    end

    CheckMotion()

    if noclip then
        NoClip()
    end

    if emf_name then
        CheckEMFS()
    end

    if player_name then
        PlayerName()
    end

    if player_highlight then
        PlayerHighlight()
    end

    if closet_name then
        ClosetName()
    end

    if closet_highlight then
        ClosetHighlight()
    end

    if equipment_name then
        EquipmentName()
    end

    if equipment_highlight then
        EquipmentHighlight()
    end
end)

game_group:AddDivider()

game_group:AddToggle('No Hold Proximityprompt', {
    Text = 'No Hold',
    Default = false,
    Tooltip = 'Removes the hold from proximityprompts',

    Callback = function(Value)
        no_hold_delay = Value
    end
})

game_group:AddToggle('Anti Ghost Touch', {
    Text = 'Anti Ghost Touch',
    Default = false,
    Tooltip = 'Prevents you from touching the ghost and dying',

    Callback = function(Value)
        anti_touch = Value
    end
})

game_group:AddSlider('Anti Touch Distance', {
    Text = 'Anti Touch Distance',
    Default = 7,
    Min = 7,
    Max = 12,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        touch_distance = Value
    end
})

game_group:AddDivider()

game_group:AddButton({
    Text = 'Collect Bone',

    Func = function()
        for i, v in next, Bone:GetDescendants() do
            if v:IsA("ProximityPrompt") and v.Name == "Bone" then
                local LastPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame + Vector3.new(0, 5, 0)
                task.wait(0.5)
                fireproximityprompt(v)
                task.wait(0.5)
                LocalPlayer.Character.HumanoidRootPart.CFrame = LastPos
                Library:Notify("Collected bone.")
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Collects the bone'
})

game_group:AddButton({
    Text = 'Enable Power',

    Func = function()
        for i, v in next, FuseBox:GetChildren() do
            if v:IsA("ProximityPrompt") and v.name == "FuseboxPrompt" then
                local LastPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                task.wait(0.2)
                fireproximityprompt(v)
                task.wait(0.2)
                LocalPlayer.Character.HumanoidRootPart.CFrame = LastPos
                local FuseBoxToggles = Workspace.Map.Fusebox
                if FuseBoxToggles then
                    if FuseBoxToggles:FindFirstChild("On").Transparency == 0 then
                        Library:Notify("Turned off power box.")
                    else
                        if FuseBoxToggles:FindFirstChild("Off").Transparency == 0 then
                            Library:Notify("Turned on power box.")
                        end
                    end
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Turns on/off the power box'
})

game_group:AddDivider()

game_group:AddButton({
    Text = 'Find Ghost Room',

    Func = function()
        local EMFTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("EquipmentModel") and LocalPlayer.Character.EquipmentModel:FindFirstChild("2")
        local EMF = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("EquipmentModel") and LocalPlayer.Character.EquipmentModel:FindFirstChild("1")

        if not EMFTool then
            Library:Notify("Equip EMF reader first!")
            return
        end

        if not EMF or EMF.Color ~= Color3.fromRGB(52, 142, 64) then
            Library:Notify("Turn on EMF first!")
            return
        end

        for _, room in ipairs(Rooms:GetChildren()) do
            if room:IsA("Folder") then
                local Hitbox = room:FindFirstChild("Hitbox")
                
                if Hitbox then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Hitbox.CFrame
                    Cam.CFrame = Hitbox.CFrame
                    task.wait(2)
                    
                    if EMFTool.Color == Color3.fromRGB(131, 156, 49) then
                        Library:Notify("Found Ghost Room: " .. room.Name)
                        GhostRoomLabel:SetText("Current Ghost Room: " .. room.Name)
                        GhostRoom = Hitbox.CFrame
                        return
                    end
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Finds the ghost current room'
})

game_group:AddButton({
    Text = 'Teleport To Ghost Room',

    Func = function()
        if GhostRoom then
            LocalPlayer.Character.HumanoidRootPart.CFrame = GhostRoom
            Library:Notify("Teleported to ghost room.")
        else
            Library:Notify("Ghost room not found.")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to the ghost room'
})

game_group:AddButton({
    Text = 'Check Freezing Temp',

    Func = function()
        local Freezing = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("EquipmentModel") and LocalPlayer.Character.EquipmentModel:FindFirstChild("Temp") and LocalPlayer.Character.EquipmentModel.Temp:FindFirstChild("SurfaceGui") and LocalPlayer.Character.EquipmentModel.Temp.SurfaceGui:FindFirstChild("TextLabel")

        if not Freezing then
            Library:Notify("Equip freezing temp thingy idk")
            return
        end

        if GhostRoom then
            local OriginalPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            LocalPlayer.Character.HumanoidRootPart.CFrame = GhostRoom
            task.wait(10)

            local Tempeture = tonumber(Freezing.Text:match("[-%d]+"))

            if Tempeture and Tempeture < 0 then
                FreezeLabel:SetText("Freezing Temp: Yes")
            else
                FreezeLabel:SetText("Freezing Temp: No")
            end

            LocalPlayer.Character.HumanoidRootPart.CFrame = OriginalPos
        else
            Library:Notify("Ghost room not found.")
        end
    end,

    DoubleClick = false,
    Tooltip = 'Checks if frozen check'
})

game_group:AddDivider()

game_group:AddButton({
    Text = 'Tp To Van',

    Func = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = Van.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to the van'
})

player_group:AddToggle('inf stamina', {
    Text = 'Inf Stamina',
    Default = false,
    Tooltip = 'Gives you inf stamina',

    Callback = function(Value)
        inf_stamina = Value
    end
})

player_group:AddToggle('spint speed modify', {
    Text = 'Sprint Speed Changer',
    Default = false,
    Tooltip = 'Changes how fast you sprint',

    Callback = function(Value)
        sprint_change = Value
    end
})

player_group:AddSlider('sprint speed value', {
    Text = 'Sprint Speed',
    Default = 1,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        sprint_speed = Value
    end
})

player_group:AddDivider()

player_group:AddToggle('Noclip', {
    Text = 'Noclip',
    Default = false,
    Tooltip = 'Lets you go through walls',

    Callback = function(Value)
        noclip = Value
    end
})

player_group:AddToggle('Enable Jump', {
    Text = 'Enable Jumping',
    Default = false,
    Tooltip = 'Lets you jump',

    Callback = function(Value)
        jump_enabled = Value
        if Value then
            LocalPlayer.Character.Humanoid.JumpPower = 30
            LocalPlayer.Character.Humanoid.JumpHeight = 7.2
        else
            LocalPlayer.Character.Humanoid.JumpPower = 0
            LocalPlayer.Character.Humanoid.JumpHeight = 0
        end
    end
})

player_group:AddToggle('Inf Jump', {
    Text = 'Inf Jump',
    Default = false,
    Tooltip = 'Lets you jump forever',

    Callback = function(Value)
        inf_jump = Value
    end
})

player_group:AddDivider()

player_group:AddToggle('3rd person', {
    Text = '3rd Person',
    Default = false,
    Tooltip = 'idk why i really added it bc its uselss',

    Callback = function(Value)
        third_person = Value
        if Value then
            LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 1, 2)
        else
            LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 0, -1)
        end
    end
})

ghost_esp_group:AddToggle('Always Visible', {
    Text = 'Always Visible Ghost',
    Default = false,
    Tooltip = 'Shows the ghost at all times',

    Callback = function(Value)
        show_ghost = Value
        if not Value then
            for i, v in next, ghost_entity:GetChildren() do
                if v:IsA("Model") then
                    local body = v:FindFirstChild("Base")
                    if body then
                        body.Transparency = 1
                    end
                end
            end
        end
    end
})

ghost_esp_group:AddToggle('Highlight Ghost', {
    Text = 'Highlight Ghost',
    Default = false,
    Tooltip = 'Highlights the ghost',

    Callback = function(Value)
        highlight_ghost = Value
        if not Value then
            for i, v in next, ghost_entity:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
            end
        end
    end
}):AddColorPicker('Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Color Picker For Highlight',

    Callback = function(Value)
        highlight_color = Value
        for i, v in next, ghost_entity:GetChildren() do
            if v:IsA("Model") and v:FindFirstChild("Highlight") then
                v.Highlight.FillColor = Value
                v.Highlight.OutlineColor = Value
            end
        end
    end
})

ghost_esp_group:AddToggle('Ghost Name', {
    Text = 'Ghost Name Esp',
    Default = false,
    Tooltip = 'Shows the ghost name',

    Callback = function(Value)
        ghost_name = Value
        if not Value then
            for i, v in next, ghost_entity:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

item_esp_group:AddToggle('Cursed Object Name Esp', {
    Text = 'Cursed Object Name Esp',
    Default = false,
    Tooltip = 'Enables Cursed Object Name Esp',

    Callback = function(Value)
        cursed_object_name = Value
        if not Value then
            for i, v in next, cursed_objects:GetChildren() do
                if (v:IsA("MeshPart") or v:IsA("Model")) and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

item_esp_group:AddToggle('Cursed Object Highlight', {
    Text = 'Cursed Object Highlight',
    Default = false,
    Tooltip = 'Highlights cursed objects',

    Callback = function(Value)
        cursed_object_highlight = Value
        if not Value then
            for i, v in next, cursed_objects:GetChildren() do
                if (v:IsA("MeshPart") or v:IsA("Model")) and v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
            end
        end
    end
}):AddColorPicker('Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Color Picker For Highlight',

    Callback = function(Value)
        cursed_object_highlight_color = Value
        for i, v in next, cursed_objects:GetChildren() do
            if (v:IsA("MeshPart") or v:IsA("Model")) and v:FindFirstChild("Highlight") then
                v.Highlight.FillColor = Value
                v.Highlight.OutlineColor = Value
            end
        end
    end
})

item_esp_group:AddDivider()

item_esp_group:AddToggle('Bone Name Esp', {
    Text = 'Bone Name Esp',
    Default = false,
    Tooltip = 'Enables Bone Name Esp',

    Callback = function(Value)
        bone_name = Value
        if not Value then
            for i, v in next, Bone:GetChildren() do
                if v:IsA("MeshPart") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

item_esp_group:AddToggle('Bone Highlight', {
    Text = 'Bone Highlight',
    Default = false,
    Tooltip = 'Highlights bones',

    Callback = function(Value)
        bone_highlight = Value
        if not Value then
            for i, v in next, Bone:GetChildren() do
                if v:IsA("MeshPart") and v.Name == "Bone" and v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
            end
        end
    end
}):AddColorPicker('Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Color Picker For Highlight',

    Callback = function(Value)
        bone_highlight_color = Value
        for i, v in next, Bone:GetChildren() do
            if v:IsA("MeshPart") and v.Name == "Bone" and v:FindFirstChild("Highlight") then
                v.Highlight.FillColor = Value
                v.Highlight.OutlineColor = Value
            end
        end
    end
})

EMF_esp_group:AddToggle('Emfs idk', {
    Text = 'Show Active EMFS',
    Default = false,
    Tooltip = 'Shows active EMFS done by ghost',

    Callback = function(Value)
        emf_name = Value
        if not Value then
            for i, v in next, EMF:GetChildren() do
                if v:IsA("Part") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

player_esp_group:AddToggle('Player Name Esp', {
    Text = 'Name Esp',
    Default = false,
    Tooltip = 'Enables name esp for players',

    Callback = function(Value)
        player_name = Value
        if not Value then
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") then
                    local espbillboard = v.Character.Head:FindFirstChild("Esp BillBoard")
                    if espbillboard then
                        espbillboard:Destroy()
                    end
                end
            end
        end
    end
})

player_esp_group:AddToggle('Player Highlight', {
    Text = 'Highlight',
    Default = false,
    Tooltip = 'Highlights players',

    Callback = function(Value)
        player_highlight = Value
        if not Value then
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character then
                    local highlight = v.Character:FindFirstChild("Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
}):AddColorPicker('Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Color Picker For Highlight',

    Callback = function(Value)
        player_highlight_color = Value
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character then
                local highlight = v.Character:FindFirstChild("Highlight")
                if highlight then
                    highlight.FillColor = Value
                    highlight.OutlineColor = Value
                end
            end
        end
    end
})

closet_esp_group:AddToggle('Closet Esp Name', {
    Text = 'Closet Esp Name',
    Default = false,
    Tooltip = 'Enables names to all closets',

    Callback = function(Value)
        closet_name = Value
        if not Value then
            for i, v in next, Closets:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

closet_esp_group:AddToggle('Closet Esp Highlight', {
    Text = 'Closet Esp Highlight',
    Default = false,
    Tooltip = 'Highlights closets',

    Callback = function(Value)
        closet_highlight = Value
        if not Value then
            for i, v in next, Closets:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
            end
        end
    end
}):AddColorPicker('Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Color Picker For Highlight',

    Callback = function(Value)
        closet_highlight_color = Value
        for i, v in next, Closets:GetChildren() do
            if v:IsA("Model") and v:FindFirstChild("Highlight") then
                v.Highlight.FillColor = Value
                v.Highlight.OutlineColor = Value
            end
        end
    end
})

equipment_esp_group:AddToggle('Equipment Esp Name', {
    Text = 'Dropped Equipment Name',
    Default = false,
    Tooltip = 'Enables names to all equipment',

    Callback = function(Value)
        equipment_name = Value
        if not Value then
            for i, v in next, dropped_equipment:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

equipment_esp_group:AddToggle('Equipment Esp Highlight', {
    Text = 'Dropped Equipment Highlight',
    Default = false,
    Tooltip = 'Highlights equipment',

    Callback = function(Value)
        equipment_highlight = Value
        if not Value then
            for i, v in next, dropped_equipment:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
            end
        end
    end
}):AddColorPicker('Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Color Picker For Highlight',

    Callback = function(Value)
        equipment_highlight_color = Value
        for i, v in next, dropped_equipment:GetChildren() do
            if v:IsA("Model") and v:FindFirstChild("Highlight") then
                v.Highlight.FillColor = Value
                v.Highlight.OutlineColor = Value
            end
        end
    end
})

world_group:AddToggle('Full Bright', {
    Text = 'Full Bright',
    Default = false,
    Tooltip = 'Enables Full Bright',

    Callback = function(Value)
        full_bright = Value
        if Value then
            Lighting.ClockTime = 12
            Lighting.GlobalShadows = false
        else
            Lighting.ClockTime = 0
            Lighting.GlobalShadows = true
        end
    end
})

world_group:AddToggle('Ambient Changer', {
    Text = 'Ambient Changer',
    Default = false,
    Tooltip = 'Changes Color of the games Ambient',

    Callback = function(Value)
        ambient_changer = Value
        if Value then
            Lighting.Ambient = ambient_changer_color
            Lighting.OutdoorAmbient = ambient_changer_color
            Lighting.ColorShift_Top = ambient_changer_color
            Lighting.ColorShift_Bottom = ambient_changer_color
        else
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        end
    end
}):AddColorPicker('Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Color Picker For Ambient',

    Callback = function(Value)
        ambient_changer_color = Value
        if ambient_changer then
            Lighting.Ambient = Value
            Lighting.OutdoorAmbient = Value
            Lighting.ColorShift_Top = Value
            Lighting.ColorShift_Bottom = Value
        end
    end
})

--// UI Settings

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = RunService.RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('Astolfo Ware | %s fps | %s ms | game: ' .. Info.Name .. ''):format(
        math.floor(FPS),
        math.floor(Stats.Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

menu_group:AddButton('Unload', function()
    no_hold_delay = false
    anti_touch = false
    sprint_change = false
    show_ghost = false
    highlight_ghost = false
    ghost_name = false
    cursed_object_name = false
    cursed_object_highlight = false
    bone_name = false
    bone_highlight = false
    inf_stamina = false
    noclip = false
    jump_enabled = false
    full_bright = false
    inf_jump = false
    third_person = false
    emf_name = false
    ambient_changer = false
    player_name = false
    player_highlight = false
    closet_name = false
    closet_highlight = false
    equipment_name = false
    equipment_highlight = false

    for i, v in next, Workspace:GetDescendants() do
        if v.Name == "Esp BillBoard" or v.Name == "Highlight" then
            v:Destroy()
        end
    end

    Lighting.ClockTime = 0
    Lighting.GlobalShadows = true
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 0, -1)

    WatermarkConnection:Disconnect()
    Connections:Disconnect()
    Library:Unload()
end)

credits_group:AddLabel('@kylosilly: Who made the script', true)

credits_group:AddButton({
    Text = 'Join our discord!',
    Func = function()
        setclipboard('https://discord.gg/frQv5QScXS')
    end,
    DoubleClick = false,
    Tooltip = 'Join our official discord server.'
})

credits_group:AddButton({
    Text = 'Kylosilly Scriptblox',
    Func = function()
        setclipboard('https://scriptblox.com/u/CatBoy')
    end,
    DoubleClick = false,
    Tooltip = 'My scriptblox profile'
})

credits_group:AddButton({
    Text = 'Kylosilly Github',
    Func = function()
        setclipboard('https://github.com/kylosilly')
    end,
    DoubleClick = false,
    Tooltip = 'My github profile'
})

menu_group:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Astolfo Ware')
SaveManager:SetFolder('Astolfo Ware/Specter')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
