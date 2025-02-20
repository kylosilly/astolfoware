local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Astolfo Ware',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local MainGroupBox = Tabs.Main:AddLeftGroupbox('Main')
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local NeverFail = false

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

MainGroupBox:AddDropdown('ItemSelectorDropdown', {
    Values = Items,
    Default = 1,
    Multi = false,

    Text = 'Select Item To Equip',
    Tooltip = 'Equips Selected Item',

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
    Tooltip = 'Equipts selected tool from dropdown'
})

MainGroupBox:AddToggle('NeverFailToggle', {
    Text = 'Never lose minigame (REQUIRES HOOKMETAMETHOD)',
    Default = false,
    Tooltip = '(REQUIRES HOOKFUNCTION) Never fails a dish so spam e and click anytime it wont fail!',

    Callback = function(Value)
        NeverFail = Value
    end
})

MenuGroup:AddButton('Unload', function() 
    NeverFail = false
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
