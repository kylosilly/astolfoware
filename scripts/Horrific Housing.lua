local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local Library = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BLibrary%5D'))()
local ThemeManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BThemeManager%5D'))()
local SaveManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BSaveManager%5D'))()

local Window = Library:CreateWindow({
    Title = 'Astolfo Ware | Made by @kylosilly',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.1
})

--// Tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    Teleports = Window:AddTab('Teleports'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

--// Groups

local InGameGroup = Tabs.Main:AddLeftGroupbox('Game Settings')
local HouseGroup = Tabs.Main:AddRightGroupbox('House Settings')
local LobbyGroup = Tabs.Main:AddLeftGroupbox('Lobby Settings')
local TpGroup = Tabs.Teleports:AddLeftGroupbox('Teleports')

--// Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(game.PlaceId)
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

--// Paths

local Ornaments = ReplicatedStorage.Ornaments
local Furnitures = ReplicatedStorage.Furniture
local LobbySpleef = workspace.Spleef
local Obby = workspace.Obby

--// Tables

local ornaments = {}
local furnitures = {}

--// Variables

local OrnamentSlot = "Ornament1"
local Ornament = ""
local Furniture = ""
local FurnitureSlot = "Furniture1"

local NoBoomDmg = false
local BringAll = false

--// Main Script

for i, v in next, Ornaments:GetChildren() do
    if v:IsA("Model") then
        table.insert(ornaments, v.Name)
    end
end

for i, v in next, Furnitures:GetChildren() do
    if v:IsA("Model") then
        table.insert(furnitures, v.Name)
    end
end

local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and self.Name == "damageMe" and NoBoomDmg and not checkcaller() then
        args[1] = 0
        return old(self, unpack(args))
    end

    return old(self, ...)
end)

function Bringall()
    for i, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Team.Name == "Playing" then
            v.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 3
        end
    end
end

RunService.RenderStepped:Connect(function()
    if BringAll then
        Bringall()
    end
end)

if hookmetamethod then
InGameGroup:AddToggle('No Explosive Damage', {
    Text = 'No Explosive Damage',
    Default = false,
    Tooltip = 'Removes explosive damage from rockets etc.',

    Callback = function(Value)
        NoBoomDmg = Value
    end
})
else
    InGameGroup:AddLabel('Your executor does not support hookmetamethod which couldnt load this feature: No Explosive Damage', true)
end

InGameGroup:AddToggle('Bring All', {
    Text = 'Bring All',
    Default = false,
    Tooltip = 'Brings all people to you (good for guns/meeles)',

    Callback = function(Value)
        BringAll = Value
    end
})

InGameGroup:AddDivider()

InGameGroup:AddButton({
    Text = 'Delete Map (Easy Wins)',
    Func = function()
        for i = 1, 7000 do
            game:GetService("ReplicatedStorage").EventRemotes.Potion:FireServer(true)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Destroys the map. (NOT RECOMMENDED TO USE FOR WEAK PCS)'
})   

InGameGroup:AddButton({
    Text = 'Hit All With Coconut',
    Func = function()
        for i, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and LocalPlayer.Character:FindFirstChild("Coconut") and v.Character:FindFirstChild("HumanoidRootPart") then
                local args = {
                    [1] = v.Character.HumanoidRootPart.Position,
                    [2] = v.Character.HumanoidRootPart,
                    [3] = 5
                }
                
                LocalPlayer.Character:FindFirstChild("Coconut").throwEvent:FireServer(unpack(args))
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Hits all players with coconut. (YOU GOTTA HOLD A COCONUT)'
})

InGameGroup:AddButton({
    Text = 'Spleef All Tiles',
    Func = function()
        local SpleefFolder = Workspace["Spleef Arena"]

        for i, v in next, SpleefFolder:GetChildren() do
            if v:IsA("Part") then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Spleef all tiles in game. (Requires Spleef Gamemode)'
})

InGameGroup:AddButton({
    Text = 'Remove Lava Kill Part',
    Func = function()
        local LavaPlate = workspace.LavaPlate
        LavaPlate:FindFirstChild("TouchInterest"):Destroy()
    end,
    DoubleClick = false,
    Tooltip = 'Removes lava kill part.'
})

InGameGroup:AddButton({
    Text = 'Remove Spinner Kill Part',
    Func = function()
        local Spinnnnnnnnnner = workspace.Spinner.Sweeper
        Spinnnnnnnnnner:FindFirstChild("TouchInterest"):Destroy()
    end,
    DoubleClick = false,
    Tooltip = 'Removes spinner kill part.'
})

InGameGroup:AddButton({
    Text = 'Expand Plate Size',
    Func = function()
        local Plates = workspace.Plates[LocalPlayer.Name]
        if Plates then
            local Plate = Plates:FindFirstChild("Plate")
            if Plate then
                Plate.Size = Vector3.new(250, 1, 250)
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Expands plate size. (ONLY CHANGES OF YOURS SO IT DOSENT EXIST THAN IT WONT WORK)'
})

InGameGroup:AddButton({
    Text = 'Remove Acid Flood Kill Part',
    Func = function()
        local KillPart = workspace.Kill
        KillPart:FindFirstChild("TouchInterest"):Destroy()
    end,
    DoubleClick = false,
    Tooltip = 'Removes Acid Flood kill part.'
})


LobbyGroup:AddButton({
    Text = 'Spleef Lobby Tiles',
    Func = function()
        for i, v in next, LobbySpleef:GetChildren() do
            if v:IsA("Part") then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Spleef tiles in lobby.'
})

LobbyGroup:AddButton({
    Text = 'Claim all Obby Rewards',
    Func = function()
        for i, v in next, Obby.ImportantParts:GetChildren() do
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Claims all aviable rewards in obby.'
})

HouseGroup:AddDropdown('Furniture Selector', {
    Values = furnitures,
    Default = "",
    Multi = false,
    Text = 'Furniture Selector',
    Tooltip = 'Select a furniture to equip.',

    Callback = function(Value)
        Furniture = Value
    end
})

HouseGroup:AddDropdown('Slot Selector', {
    Values = { 'Furniture1', 'Furniture2', 'Furniture3' },
    Default = "Furniture1",
    Multi = false,
    Text = 'Slot Selector',
    Tooltip = 'Select a slot to equip. (Furniture 1 is slot 1 etc.)',

    Callback = function(Value)
        FurnitureSlot = Value
    end
})

HouseGroup:AddButton({
    Text = 'Equip Furniture',
    Func = function()
        ReplicatedStorage:WaitForChild("FurnitureChanged"):FireServer(FurnitureSlot, Furniture)
    end,
    DoubleClick = false,
    Tooltip = 'Equips selected furniture from dropdown to selected slot. (STAYS)'
})

HouseGroup:AddDivider()

HouseGroup:AddDropdown('Ornaments Selector', {
    Values = ornaments,
    Default = "",
    Multi = false,
    Text = 'Ornaments Selector',
    Tooltip = 'Select an ornament to equip.',

    Callback = function(Value)
        Ornament = Value
    end
})

HouseGroup:AddDropdown('Slot Selector', {
    Values = { 'Ornament1', 'Ornament2', 'Ornament3' },
    Default = "Ornament1",
    Multi = false,
    Text = 'Slot Selector',
    Tooltip = 'Select a slot to equip. (Ornament 1 is slot 1 etc.)',

    Callback = function(Value)
        OrnamentSlot = Value
    end
})

HouseGroup:AddButton({
    Text = 'Equip Ornament',
    Func = function()
        ReplicatedStorage:WaitForChild("OrnamentChanged"):FireServer(OrnamentSlot, Ornament)
    end,
    DoubleClick = false,
    Tooltip = 'Equips selected ornament from dropdown to selected slot.'
})

HouseGroup:AddDivider()

HouseGroup:AddLabel('House Color'):AddColorPicker('House Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'House Color Picker',

    Callback = function(Value)
        HouseColor = Value
    end
})

HouseGroup:AddButton({
    Text = 'Change House Color',
    Func = function()
        game:GetService("ReplicatedStorage"):WaitForChild("HouseColour"):FireServer(HouseColor)        
    end,
    DoubleClick = false,
    Tooltip = 'Changes the house color.'
})

TpGroup:AddButton({
    Text = 'Tp To Illumiati',
    Func = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0.36450493335723877, 5.543025016784668, -16.87293243408203)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to Illumiati.'
})

TpGroup:AddButton({
    Text = 'Tp To Spec Button',
    Func = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(7.635685443878174, 5.498024940490723, -3.420691967010498)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to Spectate Button or wtver its called.'
})

TpGroup:AddButton({
    Text = 'Tp Infront Of Obby',
    Func = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1.1615108251571655, 17.542022705078125, -109.22512817382812)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to Spectate Button or wtver its called.'
})

TpGroup:AddButton({
    Text = 'Tp To Obby Victory1',
    Func = function()
        local Victory1 = Obby.ImportantParts.Victory1
        LocalPlayer.Character.HumanoidRootPart.CFrame = Victory1.CFrame
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to Spectate Button or wtver its called.'
})

TpGroup:AddButton({
    Text = 'Tp To Obby Victory2',
    Func = function()
        local Victory1 = Obby.ImportantParts.Victory2
        LocalPlayer.Character.HumanoidRootPart.CFrame = Victory2.CFrame
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to Spectate Button or wtver its called.'
})

--// UI Settings

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('Astolfo Ware | %s fps | %s ms | game: ' .. Info.Name .. ''):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function()
    NoBoomDmg = false
    BringAll = false
    WatermarkConnection:Disconnect()
    Library:Unload()
end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('stolfo Ware')
SaveManager:SetFolder('Astolfo Ware/Dead Rails Game')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
