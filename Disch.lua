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

local Tabs = {
    Main = Window:AddTab('Main'),
    Farm = Window:AddTab('Farm'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local MainGroupBox = Tabs.Main:AddLeftGroupbox('Main')
local FarmGroupBox = Tabs.Farm:AddLeftGroupbox('Farm')
local QuestGroupBox = Tabs.Farm:AddRightGroupbox('Quest Stuff')
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local NeverFail = false
local SellAll = false
local ModifyXp = false
local AutoFarm = false

local sinks = Workspace.restaurant.sinks
local items = ReplicatedStorage.tools
local Items = {}

for i, v in next, items:GetChildren() do
    if v:IsA("Tool") then
        table.insert(Items, v.Name)
    end
end

local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local Method = getnamecallmethod()

    if Method == "FireServer" and self.Name == "searchingInSink" and NeverFail then
        args[1] = true
    end

    return oldNamecall(self, unpack(args))
end)

local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local Method = getnamecallmethod()

    if Method == "FireServer" and self.Name == "quest" and ModifyXp then
        args[4] = XpChange
    end

    return oldNamecall(self, unpack(args))
end)

local function Autofarm()
    for _, sink in ipairs(sinks:GetChildren()) do
        if sink:IsA("Model") then
            local active = sink:FindFirstChild("active")
            if active and active:IsA("BoolValue") and not active.Value then
                local ProximityPrompt = sink:FindFirstChildOfClass("ProximityPrompt")
                if ProximityPrompt then
                    fireproximityprompt(ProximityPrompt)
                    task.wait(1)
                    mouse1click()
                    task.wait(1)
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if AutoFarm then
        Autofarm()
    end
end)

local function AutoSellItems()
    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("sell"):InvokeServer(true)
    task.wait()
end

RunService.RenderStepped:Connect(function()
    if AutoSell then
        AutoSellItems()
    end
end)

MainGroupBox:AddDropdown('ItemSelectorDropdown', {
    Values = Items,
    Default = 1,
    Multi = false,

    Text = 'Select Item To Equip.',
    Tooltip = 'Equips Selected Item.',

    Callback = function(Value)
        SelectedItem = Value
    end
})

local EquipToolButton = MainGroupBox:AddButton({
    Text = 'Equip Tool',
    Func = function()
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("toolEvent"):InvokeServer(SelectedItem, "equip")
    end,
    DoubleClick = false,
    Tooltip = 'Equips selected tool from dropdown.'
})

MainGroupBox:AddDivider()

local SellAllButton = MainGroupBox:AddButton({
    Text = 'Sell All',
    Func = function()
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("sell"):InvokeServer(true)
    end,
    DoubleClick = false,
    Tooltip = 'Sells all items.'
})

local SellHeldButton = MainGroupBox:AddButton({
    Text = 'Sell Held Item',
    Func = function()
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("sell"):InvokeServer(false)
    end,
    DoubleClick = false,
    Tooltip = 'Sells all items.'
})

local GiveInvButton = MainGroupBox:AddButton({
    Text = 'Give Fat Filly Inventory',
    Func = function()
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("eat"):InvokeServer(true)
    end,
    DoubleClick = false,
    Tooltip = 'Gives Fat Filly Your Whole Inventory (Basically not given items yet.)'
})

local GiveHeldButton = MainGroupBox:AddButton({
    Text = 'Give Fat Filly Held Item',
    Func = function()
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("eat"):InvokeServer(false)
    end,
    DoubleClick = false,
    Tooltip = 'Gives Fat Filly Held Item (Basically not given items yet.)'
})

local AppraiseButton = MainGroupBox:AddButton({
    Text = 'Appraise Held item',
    Func = function()
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("appraiseItem"):InvokeServer(LocalPlayer.Character:FindFirstChildWhichIsA("Tool"))
    end,
    DoubleClick = false,
    Tooltip = 'Appraises Held Item!'
})

MainGroupBox:AddDivider()

MainGroupBox:AddToggle('AutoSellToggle', {
    Text = 'Auto Sell All',
    Default = false,
    Tooltip = 'Automatically sells all items for you.',

    Callback = function(Value)
        AutoSell = Value
    end
})

if hookmetamethod then
FarmGroupBox:AddToggle('NeverFailToggle', {
    Text = 'Never lose minigame',
    Default = false,
    Tooltip = 'Never fails a dish so spam e and click anytime it wont fail!',

    Callback = function(Value)
        NeverFail = Value
    end
})

FarmGroupBox:AddToggle('AutoFarmToggle', {
    Text = 'Auto Farm (Buggy asf mb gang)',
    Default = false,
    Tooltip = 'Automatically farms for you (turn on Never lose minigame before you use!)',

    Callback = function(Value)
        AutoFarm = Value
    end
})
else
    FarmGroupBox:AddLabel("The feature Never Fail is hidden because your executor does not support hookmetamethod", true)
end

if hookmetamethod then
QuestGroupBox:AddSlider('XpQuestGiveSlider', {
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

QuestGroupBox:AddToggle('ModifyQuestXp', {
    Text = 'Modify Quest Xp',
    Default = false,
    Tooltip = 'When finishing a quest, changes the xp reward.',

    Callback = function(Value)
        ModifyXp = Value
    end
})
else
    FarmGroupBox:AddLabel("The feature Modify Quest Xp is hidden because your executor does not support hookmetamethod", true)
end

MenuGroup:AddButton('Unload', function() 
    NeverFail = false
    AutoSell = false
    ModifyXp = false
    AutoFarm = false
    Library:Unload() 
end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
