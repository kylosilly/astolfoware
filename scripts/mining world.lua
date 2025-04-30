--// Ignore the not done stuff :sob:
if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

if getthreadcontext() > 7 then
    print("Executor Supported")
else
    game:Shutdown()
end

local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local library = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BLibrary%5D'))()
local theme_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BThemeManager%5D'))()
local save_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BSaveManager%5D'))()

local window = library:CreateWindow({
    Title = 'Astolfo Ware | Public | Made By @kylosilly',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local tabs = {
    main = window:AddTab('Main'),
    auto = window:AddTab('Auto'),
    ['ui settings'] = window:AddTab('UI Settings')
}

local game_group = tabs.main:AddLeftGroupbox('Game Settings')
local misc_group = tabs.main:AddRightGroupbox('Misc Settings')
local farm_group = tabs.auto:AddLeftGroupbox('Auto Farm Settings')
local shop_group = tabs.auto:AddRightGroupbox('Shop Stuff')
local enchant_group = tabs.auto:AddRightGroupbox('Auto Enchant Settings')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')

local replicated_storage = cloneref(game:GetService("ReplicatedStorage"))
local market = cloneref(game:GetService("MarketplaceService"))
local run_service = cloneref(game:GetService("RunService"))
local workspace = cloneref(game:GetService("Workspace"))
local players = cloneref(game:GetService("Players"))
local stats = cloneref(game:GetService("Stats"))
local info = market:GetProductInfo(game.PlaceId)
local local_player = players.LocalPlayer

local player_functions = require(replicated_storage.Modules.PlayerFunctions)
local client_utlility = require(replicated_storage.Modules.ClientUtility)
local game_state = require(replicated_storage.Modules.GameState)
local teleports = require(replicated_storage.Modules.Teleport)
local tables = require(replicated_storage.Modules.Table)

local auto_enchant = false
local auto_mine = false

local selected_enchantment = ""
local selected_pickaxe = ""
local selected_ore = ""

local selected_amount = 1
local selected_slot = 1

local enchantments = {
    "Abnormal Speed",
    "Light Damage",
    "Considerable Luck",
    "More Damage",
    "Mighty Luck",
    "Deadly Damage",
    "Mighty++ Luck",
    "Deadly++ Damage",
    "Incredible Luck",
    "Incredible Damage",
    "Magic Ores"
}

local node_name = {}
local pickaxes = {}

local node_names = replicated_storage:FindFirstChild("Nodes")
local items = replicated_storage:FindFirstChild("Items")
local nodes = workspace:FindFirstChild("Nodes")

local selected_level = "Level 1"

for _, v in next, node_names:GetChildren() do
    table.insert(node_name, v.Name)
end

for _, v in next, items:GetChildren() do
    if v.Name:find("Pickaxe") or v.Name:find("Pick") or v.Name:find("Chopper") or v.Name:find("Sharkee") or v.Name:find("Demonaxe") then
        table.insert(pickaxes, v.Name)
    end
end

--[[
function get_inventory()
    local inventory_pickaxes = {}
    for _, v in next, game_state:GetData().Inventory do
        if v.Name:find("Pickaxe") or v.Name:find("Pick") or v.Name:find("Chopper") or v.Name:find("Sharkee") or v.Name:find("Demonaxe") then
            table.insert(inventory_pickaxes, v.Name)
        end
    end
    return inventory_pickaxes
end
]]

function closest_ore()
    local ore = nil;
    local max_distance = math.huge;

    for _, v in next, nodes:GetChildren() do
        if v:FindFirstChild("Info") and v.Info:FindFirstChild("Frame") and v.Info.Frame:FindFirstChild("SeedTitle") and v.Info.Frame.SeedTitle.Text == selected_ore then
            local distance = (local_player.Character:GetPivot().Position - v:GetPivot().Position).magnitude
            if distance < max_distance then
                max_distance = distance
                ore = v.Name
            end
        end
    end

    return ore
end

game_group:AddButton({
    Text = "Unlock Level 2",
    Func = function()
        local progression = game_state:GetData().Progression["Unlocked Level 2 Keyhole"]

        if not (progression and progression.Complete) then
            replicated_storage:WaitForChild("Remotes"):WaitForChild("GrabLevel2Key"):FireServer()
            replicated_storage:WaitForChild("Remotes"):WaitForChild("UnlockLevel2Keyhole"):FireServer()
        else
            client_utlility:AddNotification("Already unlocked level 2", Color3.fromRGB(255, 105, 180), 1)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Unlocks elevator level 2'
})

game_group:AddButton({
    Text = 'Unlock Cave',
    Func = function()
        if game_state:GetData().Money < 450 then
            client_utlility:AddNotification("Not Enough Money", Color3.fromRGB(255, 105, 180), 1)
            return
        end
        for i = 1,3 do
            replicated_storage:WaitForChild("Remotes"):WaitForChild("BuyTool"):FireServer("Dynamite")
            replicated_storage:WaitForChild("Remotes"):WaitForChild("PlaceDynamite"):FireServer(i)
        end
        replicated_storage:WaitForChild("Remotes"):WaitForChild("DetonateDynamite"):FireServer()
    end,
    DoubleClick = false,
    Tooltip = 'Unlocks cave enterance'
})

game_group:AddButton({
    Text = 'Unlock Drilling Door',
    Func = function()
        if game_state:GetData().Money < 9999 then
            client_utlility:AddNotification("Not Enough Money", Color3.fromRGB(255, 105, 180), 1)
            return
        end
        replicated_storage:WaitForChild("Remotes"):WaitForChild("GetDialogue"):InvokeServer("John", 3, 1)
        replicated_storage:WaitForChild("Remotes"):WaitForChild("UseKey"):FireServer("Drilling Site Key")
    end,
    DoubleClick = false,
    Tooltip = 'Unlocks drilling enterance'
})

game_group:AddDivider()

game_group:AddDropdown('level_selector', {
    Values = { 'Level 1', 'Level 2' },
    Default = selected_level,
    Multi = false,

    Text = 'Select Level:',
    Tooltip = 'Select a elevator level to teleport to',

    Callback = function(Value)
        selected_level = Value
    end
})

game_group:AddButton({
    Text = "Teleport To Choosen Level",
    Func = function()
        if selected_level == "Level 1" then
            teleports:UseElevator("Level 1")
            return
        elseif selected_level == "Level 2" then
            local progression = game_state:GetData().Progression["Unlocked Level 2 Keyhole"]

            if not (progression and progression.Complete) then
                client_utlility:AddNotification("You need to unlock level 2 keyhole first", Color3.fromRGB(255, 105, 180), 1)
                return
            end

            teleports:UseElevator("Level 2")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports to choosen level'
})

misc_group:AddButton({
    Text = 'Sell All',
    Func = function()
        for i, v in next, game_state:GetData().Inventory do
            if not (v.Name:find("Pickaxe") or v.Name:find("Pick") or v.Name:find("Chopper") or v.Name:find("Sharkee") or v.Name:find("Demonaxe")) then
                replicated_storage:WaitForChild("Remotes"):WaitForChild("SellItem"):FireServer(i, v.Amount)
            end
        end
    end,
    DoubleClick = true,
    Tooltip = 'Sells every ore in your inventory'
})

farm_group:AddDropdown('ore_selector', {
    Values = node_name,
    Default = selected_ore,
    Multi = false,

    Text = 'Select Ore To Mine:',
    Tooltip = 'Select a ore to auto mine',

    Callback = function(Value)
        selected_ore = Value
    end
})

farm_group:AddToggle('auto_mine', {
    Text = 'Auto Mine',
    Default = auto_mine,
    Tooltip = 'Automatically mines for you from anywhere',

    Callback = function(Value)
        auto_mine = Value
        if Value then
            if selected_ore == "" then
                client_utlility:AddNotification("You need to select an ore to mine first", Color3.fromRGB(255, 105, 180), 1)
                return
            end
            repeat
                local ore = closest_ore()
                if ore then
                    replicated_storage:WaitForChild("Remotes"):WaitForChild("DamageNode"):FireServer(ore)
                end
                task.wait(player_functions:GetPickaxeSpeed(game_state:GetData()))
            until not auto_mine
        end
    end
})

shop_group:AddDropdown('pickaxe_selector', {
    Values = pickaxes,
    Default = selected_pickaxe,
    Multi = false,

    Text = 'Select Pickaxe To Buy:',
    Tooltip = 'buys selected pickaxe from dropdown',

    Callback = function(Value)
        selected_pickaxe = Value
    end
})

shop_group:AddSlider('buy_amount', {
    Text = 'How Many Times To Buy Item:',
    Default = selected_amount,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        selected_amount = Value
    end
})

shop_group:AddButton({
    Text = 'Buy Pickaxe',
    Func = function()
        if selected_pickaxe == "" then
            client_utlility:AddNotification("You need to select a pickaxe to buy first", Color3.fromRGB(255, 105, 180), 1)
            return
        end
        replicated_storage:WaitForChild("Remotes"):WaitForChild("BuyTool"):FireServer(selected_pickaxe, selected_amount)
        client_utlility:AddNotification("Bought "..selected_amount.." "..selected_pickaxe, Color3.fromRGB(255, 105, 180), 1)
    end,
    DoubleClick = false,
    Tooltip = 'Buys selected pickaxe'
})

enchant_group:AddLabel("Releasing Next Update <3", true)

--[[
enchant_group:AddDropdown('enchant_selector', {
    Values = enchantments,
    Default = selected_enchantment,
    Multi = false,

    Text = 'Select A Enchant:',
    Tooltip = 'Select a enchant to enchant your pickaxe to', 

    Callback = function(Value)
        selected_enchantment = Value
    end
})

enchant_group:AddDropdown('pickaxe_selector', {
    Values = get_inventory(),
    Default = selected_pickaxe,
    Multi = false,

    Text = 'Select A Pickaxe:',
    Tooltip = 'Select a pickaxe to enchant', 

    Callback = function(Value)
        selected_pickaxe = Value
    end
})

enchant_group:AddDropdown('slot_selector', {
    Values = { '1', '2' },
    Default = selected_slot,
    Multi = false,

    Text = 'Select Slot To Enchant:',
    Tooltip = 'This is a tooltip',

    Callback = function(Value)
        selected_slot = Value
    end
})
]]

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local watermark_connection = run_service.RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    library:SetWatermark(('Astolfo Ware | %s fps | %s ms | game: ' .. info.Name .. ''):format(
        math.floor(FPS),
        math.floor(stats.Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

menu_group:AddButton('Unload', function()
    auto_enchant = false
    auto_mine = false
    watermark_connection:Disconnect()
    library:Unload()
end)

menu_group:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
library.ToggleKeybind = Options.MenuKeybind
theme_manager:SetLibrary(library)
save_manager:SetLibrary(library)
save_manager:IgnoreThemeSettings()
save_manager:SetIgnoreIndexes({ 'MenuKeybind' })
theme_manager:SetFolder('Astolfo Ware')
save_manager:SetFolder('Astolfo Ware/BGSI')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
