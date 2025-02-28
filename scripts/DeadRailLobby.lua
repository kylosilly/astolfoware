--// Feel free to skid this is inspired by rinns hub #loveai #show10updates 🐱
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
    Lobby = Window:AddTab('Lobby'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

--// Services
local Market = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Info = Market:GetProductInfo(game.PlaceId)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

--// Groups
local LobbyGroup = Tabs.Lobby:AddLeftGroupbox('Lobby Settings')
local SelfGroup = Tabs.Lobby:AddRightGroupbox('Self Settings')

--// Main script dont touch anything under here if you dont know what your doing

local ExitPartyButton = LobbyGroup:AddButton({
    Text = 'Exit Party',
    Func = function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ExitParty"):FireServer()
    end,
    DoubleClick = false,
    Tooltip = 'Exits the current party your in.'
})

LobbyGroup:AddDivider()

local ResetButton = LobbyGroup:AddButton({
    Text = 'Reset Avatar',
    Func = function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Reset"):FireServer()
    end,
    DoubleClick = false,
    Tooltip = 'Resets your avatar.'
})

LobbyGroup:AddDivider()

LobbyGroup:AddSlider('partyMaxPlayers', {
    Text = 'Max Players Party',
    Default = 4,
    Min = 1,
    Max = 10,
    Rounding = 10,
    Compact = false,

    Callback = function(Value)
        MaxPlayers = Value
    end
})

local CreateLobbyButton = LobbyGroup:AddButton({
    Text = 'Create Lobby',
    Func = function()
        local args = {
            [1] = {
                ["maxPlayers"] = MaxPlayers
            }
        }
        
        ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_CreateParty"):FireServer(unpack(args))
        
    end,
    DoubleClick = false,
    Tooltip = 'Creates a lobby with your selected max players.'
})

SelfGroup:AddSlider('FovSlider', { -- Rinns hub ahh feature 😭
    Text = 'Fov Changer',
    Default = 70,
    Min = 10,
    Max = 120,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        Cam.FieldOfView = Value
    end
})

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

    Library:SetWatermark(('Astoflo Ware | %s fps | %s ms | game: ' .. Info.Name):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

--// UI settings

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
local CreditsGroup = Tabs['UI Settings']:AddLeftGroupbox('Credits')

MenuGroup:AddButton('Unload', function()
    WatermarkConnection:Disconnect()
    game.Workspace.CurrentCamera.FieldOfView = 70
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
SaveManager:SetFolder('Astolfo Ware/Dead Rails Lobby')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
