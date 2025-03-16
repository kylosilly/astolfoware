--// Enjoy lol idc if it gets patched its really on how you treat this script <3
local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local Library = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BLibrary%5D'))()
local ThemeManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BThemeManager%5D'))()
local SaveManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BSaveManager%5D'))()

local Window = Library:CreateWindow({
    Title = 'Astolfo Ware | Made by @kylosilly #gooning #winterark #goontokenaii',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

--// Tabs

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

--// GroupBoxes

local crate_group = Tabs.Main:AddLeftGroupbox('Crate Stuff')
local lobby_group = Tabs.Main:AddRightGroupbox('Lobby Stuff')
local misc_group = Tabs.Main:AddLeftGroupbox('Misc Stuff')
local menu_group = Tabs['UI Settings']:AddLeftGroupbox('Menu')
local credits_group = Tabs['UI Settings']:AddRightGroupbox('Credits')

--// Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(game.PlaceId)
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

--// Paths

local crates = ReplicatedStorage.Shared.Cases

--// Tables

local blacklisted_crates = {
    "Daily",
    "Case1",
    "Case2",
    "Halloween",
    "Halloween2024Collection",
    "Holiday2024Collection",
    "HolidayCollection",
    "Lunar2024Collection",
    "MetalsCollection", -- I blacklisted these because they cost ~ 999k cash shown in the module (You can always remove it from the blacklist)
    "Summer2024Collection"
}

local maps = {
    "Selecting",
    "Asylum",
    "Arcade",
    "Bunker 04",
    "Clinic",
    "Cozy Home",
    "Family Home",
    "Hideout",
    "Lodge",
    "Luxury Home",
    "Rural Home",
    "Safehouse",
    "Cargo",
    "Tridents HQ",
    "Village",
    "Haunted Mansion",
    "Classic Chalet",
    "Art Gallery",
    "Alleyway",
    "Chalet",
    "Classic Clinic",
    "Factory",
    "Private Home",
    "Town"
}

local difficulties = {
    "Normal",
    "Hard",
    "Insanity"
}

local avaible_crates = {}
local avaible_maps = {}
local avaible_difficulties = {}

--// Variables

local selected_crate = ""
local selected_map = "Cargo"
local selected_difficulty = "Insanity"

--// Main Script

for i, v in pairs(crates:GetChildren()) do
    if not table.find(blacklisted_crates, v.Name) then
        table.insert(avaible_crates, v.Name)
    end
end

for i, v in pairs(maps) do
    table.insert(avaible_maps, v)
end

for i, v in pairs(difficulties) do
    table.insert(avaible_difficulties, v)
end

crate_group:AddDropdown('crate selector', {
    Values = avaible_crates,
    Default = "",
    Multi = false,

    Text = 'Select Crate',
    Tooltip = 'Select which crate you wanna open',

    Callback = function(Value)
        selected_crate = Value
    end
})

crate_group:AddButton({
    Text = 'Open Crate',
    Func = function()
        if selected_crate then
            ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CaseService"):WaitForChild("RF"):WaitForChild("PurchaseCase"):InvokeServer(selected_crate)
        else
            Library:Notify('Couldnt open crate because no crate was selected')
        end
    end,
    DoubleClick = false,
    Tooltip = 'Open selected crate'
})

lobby_group:AddLabel('Lobby creator lets you use any custom name like uwu owo im a skid dosent let you in the lobby but lets you view it but your still in it', true)

lobby_group:AddInput('lobby name', {
    Default = 'Pls free potassium key ❤️',
    Numeric = false,
    Finished = false,

    Text = 'Write anything here to put as lobby name',
    Tooltip = 'Change to whatever you wrote inside the text box',

    Placeholder = 'your a nn skid ❤️',

    Callback = function(Value)
        lobby_name = Value
    end
})

lobby_group:AddButton({
    Text = 'Create Lobby',
    Func = function()
        if lobby_name then
            ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("CreateLobby"):InvokeServer(lobby_name, 4, 0, "Public")
            Library:Notify('Lobby created with name: ' .. lobby_name)
        else
            Library:Notify('Stupid fucking retard, you cant create a lobby without a name (Well you cant but still nu)')
        end
    end,
    DoubleClick = false,
    Tooltip = 'Creates a lobby'
})

lobby_group:AddDivider()

lobby_group:AddDropdown('map selector', {
    Values = avaible_maps,
    Default = "Cargo",
    Multi = false,

    Text = 'Select Map',
    Tooltip = 'Select which map you wanna do',

    Callback = function(Value)
        selected_map = Value
    end
})

lobby_group:AddButton({
    Text = 'Change map',
    Func = function()
        if selected_map then
            ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Map", selected_map)
        else
            Library:Notify('Couldnt select map because no map was selected')
        end
    end,
    DoubleClick = false,
    Tooltip = 'Selects selected map'
})

lobby_group:AddDivider()

lobby_group:AddDropdown('difficulty selector', {
    Values = avaible_difficulties,
    Default = "Insanity",
    Multi = false,

    Text = 'Select Difficulty',
    Tooltip = 'Select which difficulty you wanna do',

    Callback = function(Value)
        selected_difficulty = Value
    end
})

lobby_group:AddButton({
    Text = 'Change difficulty',
    Func = function()
        if selected_difficulty then
            ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Difficulty", selected_difficulty)
        else
            Library:Notify('Couldnt select difficulty because no difficulty was selected')
        end
    end,
    DoubleClick = false,
    Tooltip = 'Selects selected difficulty'
})

lobby_group:AddDivider()

lobby_group:AddButton({
    Text = 'Leave Lobby',
    Func = function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptLeave"):InvokeServer()
    end,
    DoubleClick = false,
    Tooltip = 'Joins a random lobby'
})

lobby_group:AddButton({
    Text = 'Start Game (Must be host)',
    Func = function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptStart"):InvokeServer()
    end,
    DoubleClick = false,
    Tooltip = 'starts game'
})

misc_group:AddButton({
    Text = 'Join Test Lobby',
    Func = function()
        TeleportService:Teleport(10046715749, LocalPlayer)
    end,
    DoubleClick = false,
    Tooltip = 'teleports you to specter test lobby'
})

misc_group:AddButton({
    Text = 'Join Test Game',
    Func = function()
        TeleportService:Teleport(10089085851, LocalPlayer)
    end,
    DoubleClick = false,
    Tooltip = 'teleports you to specter test game'
})

misc_group:AddButton({
    Text = 'Join Test Trading',
    Func = function()
        TeleportService:Teleport(13988564812, LocalPlayer)
    end,
    DoubleClick = false,
    Tooltip = 'teleports you to specter test trading game'
})

misc_group:AddButton({
    Text = 'Spin Wheel',
    Func = function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("WheelService"):WaitForChild("RF"):WaitForChild("Spin"):InvokeServer()
    end,
    DoubleClick = false,
    Tooltip = 'teleports you to specter hub'
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
    WatermarkConnection:Disconnect()
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
SaveManager:SetFolder('Astolfo Ware/Specter Lobby')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
