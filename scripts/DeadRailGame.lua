--// Feel free to skid this is inspired by rinns hub #loveai #show10updates 🐱
local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local Library = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BLibrary%5D'))()
local ThemeManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BThemeManager%5D'))()
local SaveManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BSaveManager%5D'))()

--// Services
ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Market = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local Info = Market:GetProductInfo(game.PlaceId)
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting =game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local LocalPlayer = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

local Window = Library:CreateWindow({
    Title = 'Astolfo Ware (Had to remove lots of features cuz game patches)',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

--// Tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    Esp = Window:AddTab('Esp'),
    Misc = Window:AddTab('Misc'),
    GunMods = Window:AddTab('Gun mods'),
    GunModsTutorial = Window:AddTab('Gun Mods Tutorial Ussage'),
    World = Window:AddTab('World'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

--// GroupBoxes
local AutoDoGroup = Tabs.Main:AddLeftGroupbox('Auto Settings')
local ItemsGroup = Tabs.Main:AddRightGroupbox('Item Settings')
local RinnsHubEspGroup = Tabs.Esp:AddLeftGroupbox('Esp Settings')
local MiscGroup = Tabs.Misc:AddLeftGroupbox('Misc Settings')
local GunModGroup = Tabs.GunMods:AddLeftGroupbox('Gun Mods')
local GunModExplainedGroup = Tabs.GunModsTutorial:AddRightGroupbox('Gun Mods Tutorial Use')
local WorldGroup = Tabs.World:AddLeftGroupbox('World Settings')

--// Variables
local ShowTextRuntimeItems = false
local nobandagedelay = false
local AmbientChanger = false
local ApplyGunMods = false
local ThirdPerson = false
local AutoHeal = false
local Fb = false

--// Main Script DONT TOUCH ANYTHING UNDER HERE IF YOU DONT KNOW WHAT YOUR DOING

RunService.RenderStepped:Connect(function()
    if nobandagedelay and LocalPlayer.PlayerGui.BandageUse.Enabled and LocalPlayer.Character then
        local Bandage = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Bandage")
        if Bandage ~= nil then
            Bandage.Use:FireServer()
        end
    end

    if ShowTextRuntimeItems then
        for i, v in next, RuntimeItems:GetChildren() do
            if v:IsA("Model") and v:FindFirstChild("ObjectInfo") then
                v.ObjectInfo.Enabled = true
                v.ObjectInfo.StudsOffset = Vector3.new(0, 0, 0)
                v.ObjectInfo.Size = UDim2.new(XSizeText, 0, YSizeText, 0)
            end
        end
    end

    if ApplyGunMods and LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
        local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        local Config = Tool:FindFirstChildWhichIsA("Configuration")
        if Tool.Name == "NavyRevolver" or Tool.Name == "Shotgun" or Tool.Name == "Rifle" or Tool.Name == "Sawed-Off Shotgun" or Tool.Name == "Revolver" or Tool.Name == "Mauser" then
            if Config and (Config:FindFirstChild("FireDelay") or Config:FindFirstChild("SpreadAngle") or Config:FindFirstChild("ReloadDuration")) then
                Config.FireDelay.Value = firerate
                Config.SpreadAngle.Value = spread
                Config.ReloadDuration.Value = reloadtime
            end
        end
    end

    if AutoHeal and LocalPlayer.Character.Humanoid.Health < HealAt then
        local Bandage = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bandage")
        if Bandage ~= nil then
            Bandage.Use:FireServer()
        end
    end

    if Fb then
        Lighting.ClockTime = 14.5
        Lighting.Brightness = 3
    end

    if AmbientChanger then
        Lighting.Ambient = AmbientColor
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if noholddelay then
        prompt.HoldDuration = 0
    end
end)

AutoDoGroup:AddSlider('MySlider', {
    Text = 'Auto Heal At:',
    Default = 45,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        HealAt = Value
    end
})

AutoDoGroup:AddToggle('AutoHeal', {
    Text = 'Auto Heal',
    Default = false,
    Tooltip = 'Automatically heals you',
    Callback = function(Value)
        AutoHeal = Value
    end
})

ItemsGroup:AddToggle('Noholddelay', {
    Text = 'No proximityprompts hold time',
    Default = false,
    Tooltip = 'Removes hold time from proximityprompts.',

    Callback = function(Value)
        noholddelay = Value
    end
})

ItemsGroup:AddToggle('Nobandagedelay', {
    Text = 'No bandage delay use',
    Default = false,
    Tooltip = 'BOI TS IS SO TUFF IT REMOVES THE WAIT FOR BANDAGE USE AND ITS INSTANT WOOW #NOTSKIDDED',

    Callback = function(Value)
        nobandagedelay = Value
    end
})

RinnsHubEspGroup:AddToggle('RuntimeItems', {
    Text = 'Turn on text at all times',
    Default = false,
    Tooltip = 'Keeps the text of all items enabled at all distances',

    Callback = function(Value)
        ShowTextRuntimeItems = Value
        if not Value then
            for i, v in next, RuntimeItems:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("ObjectInfo") then
                    v.ObjectInfo.Enabled = false
                    v.ObjectInfo.StudsOffset = Vector3.new(0, 2,5, 0)
                    v.ObjectInfo.Size = UDim2.new(3, 0, 3, 0)
                end
            end
        end
    end
})

RinnsHubEspGroup:AddSlider('XSizeText', {
    Text = 'Size change X',
    Default = 3,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        XSizeText = Value
    end
})

RinnsHubEspGroup:AddSlider('YSizeText', {
    Text = 'Size change Y',
    Default = 3,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        YSizeText = Value
    end
})

MiscGroup:AddSlider('Fov', { -- BOI TS SO TUFF ESP FOR AI YOU CAN FEEL THE PAIN IN HIS DIH
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

MiscGroup:AddDivider()

MiscGroup:AddButton({
    Text = 'Rejoin',
    Func = function()
        if #Players:GetPlayers() <= 1 then
            Players.LocalPlayer:Kick("Rejoining...")
            wait()
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Rejoins the server for you (Thanks to inf yield for this <3)'
})

MiscGroup:AddButton({
    Text = 'Server Hop',
    Func = function()
        if httprequest then
            local servers = {}
            local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", game.PlaceId)})
            local body = HttpService:JSONDecode(req.Body)
            
            if body and body.data then
                for _, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                        table.insert(servers, v.id)
                    end
                end
            end

            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
            else
                Library:Notify("Serverhop: Couldn't find a server.")
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Serverhops for you (Thanks to inf yield for this too also <3)'
})

MiscGroup:AddDivider()

MiscGroup:AddToggle('3rdPerson', {
    Text = '3rd Person',
    Default = false,
    Tooltip = 'THIS IS SO RINNS HUB BOIII (Useless feature 😭)',

    Callback = function(Value)
        ThirdPerson = Value
        if Value then
            Players.LocalPlayer.CameraMode = "Classic"
            Players.LocalPlayer.CameraMaxZoomDistance = 12
            Players.LocalPlayer.CameraMinZoomDistance = 12
        elseif not Value then
            Players.LocalPlayer.CameraMode = "LockFirstPerson"
        end
    end
})

GunModExplainedGroup:AddLabel('If a setting gets flagged and you fire too fast or exceed the limit, the game will return the bullets. To remove gun mods, set the value back to false, adjust the slider, or drop and pick up the gun again.', true)

GunModGroup:AddSlider('Firerate', {
    Text = 'Firerate Changer',
    Default = 0.3,
    Min = 0.1,
    Max = 3,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        firerate = Value
    end
})

GunModGroup:AddSlider('Spread', {
    Text = 'Spread Changer',
    Default = 0.7,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        spread = Value
    end
})

GunModGroup:AddSlider('ReloadTime', {
    Text = 'Reload Time Changer',
    Default = 2,
    Min = 0.1,
    Max = 3,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        reloadtime = Value
    end
})

GunModGroup:AddToggle('ApplyGunMods', {
    Text = 'Apply Gun Mods',
    Default = false,
    Tooltip = 'Applys gun mods',

    Callback = function(Value)
        ApplyGunMods = Value
    end
})

WorldGroup:AddToggle('FbToggle', {
    Text = 'Full Bright',
    Default = false,
    Tooltip = 'This so bright it makes it daylight',

    Callback = function(Value)
        Fb = Value
        if not Value then
            Lighting.Brightness = 14.5
            Lighting.Brightness = 1.5
        end
    end
})

WorldGroup:AddToggle('AmbientChanger', {
    Text = 'Ambient Changer',
    Default = false,
    Tooltip = 'Changes Color of Ambient',

    Callback = function(Value)
        AmbientChanger = Value
        if not Value then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        end
    end
}):AddColorPicker('AmbientColorPicker', {
    Default = Color3.fromRGB(156, 156, 156),
    Title = 'Ambient Color Changer',

    Callback = function(Value)
        AmbientColor = Value
    end
})

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

    Library:SetWatermark(('Astolfo Ware | %s fps | %s ms | game: ' .. Info.Name):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

--// UI settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
local CreditsGroup = Tabs['UI Settings']:AddLeftGroupbox('Credits')

MenuGroup:AddButton('Unload', function()
    ShowTextRuntimeItems = false
    Fb = false
    AmbientChanger = false
    ThirdPerson = false
    noholddelay = false
    nobandagedelay = false
    ApplyGunMods = false
    AutoHeal = false
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
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
ThemeManager:SetFolder('stolfo Ware')
SaveManager:SetFolder('Astolfo Ware/Dead Rails Game')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
