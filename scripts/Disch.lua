--// Gui Lib 🏳️‍🌈
local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local Library = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BLibrary%5D'))()
local ThemeManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BThemeManager%5D'))()
local SaveManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BSaveManager%5D'))()

local Window = Library:CreateWindow({
    Title = 'Astolfo Ware 🏳️‍🌈',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.15
})

Library:Notify('Script made by @kylosilly thanks @netpa for helping me optimize the script and helping me fix some issues!')

if not hookmetamethod then
    Library:Notify('Your executor does not support hookmetamethod which couldnt load these features: Auto Farm, Modify Quest Xp, Never Fail.')
end

-- Tabs 🏳️‍🌈
local Tabs = {
    Main = Window:AddTab('Main'),
    Farm = Window:AddTab('Farm'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

--// GroupBoxes 🏳️‍🌈
local MainGroup = Tabs.Main:AddLeftGroupbox('Main')
local FarmGroup = Tabs.Farm:AddLeftGroupbox('Farm')
local QuestGroup = Tabs.Farm:AddRightGroupbox('Quest Stuff')
local MiscGroup = Tabs.Misc:AddLeftGroupbox('Misc')

--// Services 🏳️‍🌈
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(game.PlaceId)
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Stats = game:GetService("Stats")

--// Variables 🏳️‍🌈
local NeverFail = false
local AutoSell = false
local ModifyXp = false
local AutoFarmNeverFail = false

--// Items 🏳️‍🌈
local sinks = Workspace.restaurant.sinks
local items = ReplicatedStorage.tools

--// Storages 🏳️‍🌈
local Items = {}

--// Do NOT touch anything under here if you dont know what you are doing. 🏳️‍🌈
if hookmetamethod then
    local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local Method = getnamecallmethod()

        if Method == "FireServer" and self.Name == "searchingInSink" and NeverFail and not checkcaller() then
            args[1] = true
        elseif Method == "FireServer" and self.Name == "quesst" and ModifyXp and not checkcaller() then
            args[4] = XpChange
        end

        return oldNamecall(self, table.unpack(args))
    end)
end

--// Functions 🏳️‍🌈
local function Autofarmneverfail()
    for _, sink in ipairs(sinks:GetChildren()) do
        if sink:IsA("Model") then
            local active = sink:FindFirstChild("active")
            if active and active:IsA("BoolValue") and not active.Value then
                local ProximityPrompt = sink:FindFirstChildOfClass("ProximityPrompt")
                if ProximityPrompt then
                    fireproximityprompt(ProximityPrompt)
                    if Players.LocalPlayer.PlayerGui.gameui["skill test"].background.Visible == true then
                    task.wait(1)
                    mouse1click()
                    task.wait(1)
                end
            end
        end
    end
end
end

local function AutoSellItems()
    ReplicatedStorage:WaitForChild("events"):WaitForChild("sell"):InvokeServer(true)
    task.wait(AutoSellDelay)
end

local function NoClip()
    if LocalPlayer.Character.Torso then
        LocalPlayer.Character.Torso.CanCollide = false
        LocalPlayer.Character.Head.CanCollide = false
    else
        LocalPlayer.Character.Torso.CanCollide = true
        LocalPlayer.Character.Head.CanCollide = true
    end
end

--// Main 🏳️‍🌈
RunService.RenderStepped:Connect(function()
    if AutoFarmNeverFail then
        Autofarmneverfail()
    end
end)

RunService.RenderStepped:Connect(function()
    if AutoSell then
        AutoSellItems()
    end
end)

RunService.RenderStepped:Connect(function()
    if NoClipEnabled then
        NoClip()
    end
end)

for i, v in next, items:GetChildren() do
    if v:IsA("Tool") then
        table.insert(Items, v.Name)
    end
end

MainGroup:AddDropdown('ItemSelectorDropdown', {
    Values = Items,
    Default = 1,
    Multi = false,

    Text = 'Select Item To Equip.',
    Tooltip = 'Equips Selected Item.',

    Callback = function(Value)
        SelectedItem = Value
    end
})

local EquipToolButton = MainGroup:AddButton({
    Text = 'Equip Tool',
    Func = function()
        ReplicatedStorage:WaitForChild("events"):WaitForChild("toolEvent"):InvokeServer(SelectedItem, "equip")
    end,
    DoubleClick = false,
    Tooltip = 'Equips selected tool from dropdown.'
})

MainGroup:AddDivider()

local SellAllButton = MainGroup:AddButton({
    Text = 'Sell All',
    Func = function()
        ReplicatedStorage:WaitForChild("events"):WaitForChild("sell"):InvokeServer(true)
    end,
    DoubleClick = false,
    Tooltip = 'Sells all items.'
})

local SellHeldButton = MainGroup:AddButton({
    Text = 'Sell Held Item',
    Func = function()
        ReplicatedStorage:WaitForChild("events"):WaitForChild("sell"):InvokeServer(false)
    end,
    DoubleClick = false,
    Tooltip = 'Sells all items.'
})

local GiveInvButton = MainGroup:AddButton({
    Text = 'Give Fat Filly Inventory',
    Func = function()
        ReplicatedStorage:WaitForChild("events"):WaitForChild("eat"):InvokeServer(true)
    end,
    DoubleClick = false,
    Tooltip = 'Gives Fat Filly Your Whole Inventory (Basically not given items yet.)'
})

local GiveHeldButton = MainGroup:AddButton({
    Text = 'Give Fat Filly Held Item',
    Func = function()
        ReplicatedStorage:WaitForChild("events"):WaitForChild("eat"):InvokeServer(false)
    end,
    DoubleClick = false,
    Tooltip = 'Gives Fat Filly Held Item (Basically not given items yet.)'
})

local AppraiseButton = MainGroup:AddButton({
    Text = 'Appraise Held item',
    Func = function()
        ReplicatedStorage:WaitForChild("events"):WaitForChild("appraiseItem"):InvokeServer(LocalPlayer.Character:FindFirstChildWhichIsA("Tool"))
    end,
    DoubleClick = false,
    Tooltip = 'Appraises Held Item!'
})

MainGroup:AddDivider()

MainGroup:AddToggle('AutoSellToggle', {
    Text = 'Auto Sell All',
    Default = false,
    Tooltip = 'Automatically sells all items for you.',

    Callback = function(Value)
        AutoSell = Value
    end
})

MainGroup:AddSlider('AutoSellDelaySlider', {
    Text = 'Auto Sell Delay',
    Default = 0,
    Min = 0,
    Max = 600,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        AutoSellDelay = Value
    end
})

if hookmetamethod then
FarmGroup:AddToggle('NeverFailToggle', {
    Text = 'Never lose minigame',
    Default = false,
    Tooltip = 'Never fails a dish so spam e and click anytime it wont fail!',

    Callback = function(Value)
        NeverFail = Value
    end
})

FarmGroup:AddToggle('AutoFarmToggle', {
    Text = 'Auto Farm Neverlose (Buggy asf mb gang)',
    Default = false,
    Tooltip = 'Automatically farms for you (turn on Never lose minigame before you use!)',

    Callback = function(Value)
        AutoFarmNeverFail = Value
    end
})
else
    FarmGroup:AddLabel("The feature Never Fail is hidden because your executor does not support hookmetamethod", true)
end

if hookmetamethod then
QuestGroup:AddSlider('XpQuestGiveSlider', {
    Text = 'Choose Modified Xp',
    Default = 5,
    Min = 1,
    Max = 9e9,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        XpChange = Value
    end
})

QuestGroup:AddToggle('ModifyQuestXp', {
    Text = 'Modify Quest Xp',
    Default = false,
    Tooltip = 'When finishing a quest, changes the xp reward.',

    Callback = function(Value)
        ModifyXp = Value
    end
})
else
    QuestGroup:AddLabel("The feature Modify Quest Xp is hidden because your executor does not support hookmetamethod", true)
end

MiscGroup:AddSlider('FOVSlider', {
    Text = 'Fov Changer',
    Default = 70,
    Min = 10,
    Max = 120,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        game.Workspace.Camera.FieldOfView = Value
    end
})

MiscGroup:AddSlider('WalkSpeedSlider', {
    Text = 'Walkspeed Changer',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

MiscGroup:AddSlider('JumpPowerSlider', {
    Text = 'Jumppower Changer',
    Default = 50,
    Min = 50,
    Max = 100,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

MiscGroup:AddToggle('NoClipToggle', {
    Text = 'No Clip',
    Default = false,
    Tooltip = 'Allows you to clip through walls.',

    Callback = function(Value)
        NoClipEnabled = Value
    end
})

Library:SetWatermarkVisibility(true)

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

    Library:SetWatermark(('Astolfo Ware | %s fps | %s ms | game: ' .. Info.Name):format(
        math.floor(FPS),
        math.floor(Stats.Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

--// UI Library Settings 🏳️‍🌈

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
local CreditsGroup = Tabs['UI Settings']:AddLeftGroupbox('Credits')

MenuGroup:AddButton('Unload', function() 
    AutoFarmNeverFail = false
    AutoSell = false
    ModifyXp = false
    AutoFarm = false
    NoClipEnabled = false
    WatermarkConnection:Disconnect()
    game.Workspace.Camera.FieldOfView = 70
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    Library:Unload() 
end)

CreditsGroup:AddLabel('@kylosilly: Who made the script', true)

CreditsGroup:AddButton({
    Text = 'Join our discord!',
    Func = function()
        setclipboard('https://discord.gg/frQv5QScXS')
    end,
    DoubleClick = false,
    Tooltip = 'Join our official discord server.'
})

CreditsGroup:AddButton({
    Text = 'Kylosilly Scriptblox',
    Func = function()
        setclipboard('https://scriptblox.com/u/CatBoy')
    end,
    DoubleClick = false,
    Tooltip = 'My scriptblox profile'
})

CreditsGroup:AddButton({
    Text = 'Kylosilly Github',
    Func = function()
        setclipboard('https://github.com/kylosilly')
    end,
    DoubleClick = false,
    Tooltip = 'My github profile'
})

CreditsGroup:AddLabel('@netpa: Helped me optimize the script/Gave me some tips/ideas', true)

CreditsGroup:AddButton({
    Text = 'Netpa Scriptblox',
    Func = function()
        setclipboard('https://scriptblox.com/u/netpa')
    end,
    DoubleClick = false,
    Tooltip = 'Netpa scriptblox profile'
})

CreditsGroup:AddButton({
    Text = 'Netpa Github',
    Func = function()
        setclipboard('https://github.com/61netpa')
    end,
    DoubleClick = false,
    Tooltip = 'Netpa github profile'
})

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Astolfo Ware')
SaveManager:SetFolder('Astolfo Ware/Disch')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
