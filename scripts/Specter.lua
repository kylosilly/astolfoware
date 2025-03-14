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

Library:Notify('Script made by @kylosilly the script is still in development and will get more features soon.', 15)

--// Tabs

local Tabs = {
    Main = Window:AddTab('Main'),
    Esp = Window:AddTab('Esp'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

--// GroupBoxes

local game_group = Tabs.Main:AddLeftGroupbox('Game Settings')
local player_group = Tabs.Main:AddRightGroupbox('Player Settings')
local ghost_esp_group = Tabs.Esp:AddLeftGroupbox('Ghost Esp Settings')
local item_esp_group = Tabs.Esp:AddRightGroupbox('Item Esp Settings')
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
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Stats = game:GetService("Stats")

--// Variables

local no_hold_delay = false
local anti_touch = false
local sprint_change = false
local show_ghost = false
local highlight_ghost = false
local ghost_name = false
local cursed_object_name = false
local cursed_object_highlight = false
local bone_name = false
local bone_highlight = false
local inf_stamina = false
local MotionCheck = true

local touch_distance = 5
local sprint_speed = 1

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
local Blockers = Workspace.Map.Blockers
local Closets = Workspace.Map.Closets
local Doors = Workspace.Map.Doors
local Bone = Workspace.Map
local MotionGrid = Workspace.Dynamic.Evidence.MotionGrids

--// Main Script

print("Enjoy the script!" .. LocalPlayer.DisplayName)
print("Device: " .. Device)
print("LocalPlayer GID: " .. GID)
print("Join Time: " .. os.date("%Y-%m-%d %H:%M:%S", Join))

function InfStamina()
    LocalPlayer:SetAttribute("Stamina", 100)
end

function ChangeSprintSpeed()
    LocalPlayer:SetAttribute("Speed", sprint_speed)
end

local OrbLabel = game_group:AddLabel('Found Orbs: False')
local FingerprintsLabel = game_group:AddLabel('Found Fingerprint: False')
local EMFLabel = game_group:AddLabel('Last Seen EMF: None')
local MotionLabel = game_group:AddLabel('Motion: None')

EMF.ChildAdded:Connect(function(child)
    if child:IsA("Part") then
        EMFLabel:SetText("Last Seen EMF: " .. child.Name)
    end
end)

Orb.ChildAdded:Connect(function(child)
    if child:IsA("Part") then
        OrbLabel:SetText("Found Orbs: True")
    end
end)

Fingerprints.ChildAdded:Connect(function(child)
    if child:IsA("Part") then
        FingerprintsLabel:SetText("Found Fingerprint: True")
    end
end)

function CheckMotion()
    for i, v in pairs(MotionGrid:GetDescendants()) do
        if v:IsA("Part") then
            if v.Color == Color3.fromRGB(252, 52, 52) then
                MotionLabel:SetText("Motion: True")
            elseif v.BrickColor == BrickColor.new("Toothpaste") then
                MotionLabel:SetText("Motion: False")
            end
        end
    end
end

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if no_hold_delay then
        prompt.HoldDuration = 0
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

    if MotionCheck then
        CheckMotion()
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
    Default = 5,
    Min = 5,
    Max = 12,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        touch_distance = Value
    end
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

    for i, v in next, Workspace:GetDescendants() do
        if v.Name == "Esp BillBoard" or v.Name == "Highlight" then
            v:Destroy()
        end
    end

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
ThemeManager:SetFolder('stolfo Ware')
SaveManager:SetFolder('Astolfo Ware/Horrific Housing')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
