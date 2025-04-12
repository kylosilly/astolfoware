--// Made by @kylosilly on discord
if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local library = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BLibrary%5D'))()
local theme_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BThemeManager%5D'))()
local save_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BSaveManager%5D'))()

local version = "V1.5.0"

local window = library:CreateWindow({
    Title = 'Astolfo Ware | Public | Made By @kylosilly | Version: ' .. version,
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local tabs = {
    main = window:AddTab('Main'),
    misc = window:AddTab('Misc'),
    ['ui settings'] = window:AddTab('UI Settings')
}

local game_group = tabs.main:AddLeftGroupbox('Game Settings')
local misc_group = tabs.main:AddRightGroupbox('Misc Settings')
local minigames_group = tabs.main:AddLeftGroupbox('Minigames Settings')
local enchant_group = tabs.main:AddRightGroupbox('Enchantment Settings')
local auto_group = tabs.misc:AddLeftGroupbox('Auto Settings')
local teleport_group = tabs.misc:AddRightGroupbox('Teleport Stuff')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')
local settings_group = tabs['ui settings']:AddRightGroupbox('Menu Settings')

local replicated_storage = game:GetService('ReplicatedStorage')
local tween_service = game:GetService('TweenService')
local market = game:GetService('MarketplaceService')
local run_service = game:GetService('RunService')
local info = market:GetProductInfo(game.PlaceId)
local workspace = game:GetService('Workspace')
local players = game:GetService('Players')
local local_player = players.LocalPlayer
local stats = game:GetService('Stats')

local islands = workspace.Worlds["The Overworld"].Islands
local pickables = workspace.Rendered:GetChildren()[12]
local chest = workspace.Rendered.Chests
local gifts = workspace.Rendered.Gifts
local rifts = workspace.Rendered.Rifts

local claim_playtime = false
local claim_seasonal = false
local auto_gold_orb = false
local collect_chest = false
local claim_tickets = false
local auto_collect = false
local auto_enchant = false
local auto_potion = false
local spin_wheel = false
local equip_best = false
local auto_doggy = false
local auto_open = false
local auto_blow = false
local auto_sell = false
local stop_at = false

local selected_enchant_method = 'Reroll All'
local selected_enchant = ''
local selected_potion = ''
local selected_island = ''
local pet_guid = ''

local selected_enchant_slot = 1
local selected_potion_tier = 1
local potion_use_delay = 1
local collect_speed = 0
local open_amount = 10

local island_names = {}

local enchantments = {
    "⚡ Team Up I",
    "⚡ Team Up II",
    "⚡ Team Up III",
    "⚡ Team Up IV",
    "⚡ Team Up V",
    "💰 Looter I",
    "💰 Looter II",
    "💰 Looter III",
    "💰 Looter IV",
    "💰 Looter V",
    "🫧 Bubbler I",
    "🫧 Bubbler II",
    "🫧 Bubbler III",
    "🫧 Bubbler IV",
    "🫧 Bubbler V",
    "✨ Gleaming I",
    "✨ Gleaming II",
    "✨ Gleaming III"
}

local potions = {
    "Speed",
    "Lucky",
    "Coins",
    "Mythic"
}

for _, v in next, islands:GetChildren() do
    table.insert(island_names, v.Name)
end

local connections = run_service.RenderStepped:Connect(function()
    if auto_blow then
        replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("BlowBubble")
    end

    if auto_sell then
        replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("SellBubble")
    end
end)

game_group:AddToggle('auto_blow', {
    Text = 'Auto Blow Bubble',
    Default = false,
    Tooltip = 'Blows for you AYO SUS BAKA',
    Callback = function(Value)
        auto_blow = Value
    end
}):AddKeyPicker('auto_blow_keybind', {
    Default = '',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Blow Bubble Keybind',
    NoUI = false,
    Callback = function()
    end,
})

game_group:AddToggle('auto_sell', {
    Text = 'Auto Sell Bubbles',
    Default = false,
    Tooltip = 'Auto Sells Your Bubbles',
    Callback = function(Value)
        auto_sell = Value
    end
}):AddKeyPicker('auto_sell_keybind', {
    Default = '',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Sell Bubble Keybind',
    NoUI = false,
    Callback = function()
    end,
})

game_group:AddDivider()

game_group:AddLabel("To use this feature you gotta unlock last zone", true)

game_group:AddToggle('auto_collect', {
    Text = 'Auto Collect Coins/Gems',
    Default = false,
    Tooltip = 'Auto Collects Coins/Gems',
    Callback = function(Value)
        auto_collect = Value
        if Value then
            replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands.Zen.Island.Portal.Spawn")
        end
        task.wait(1)
        while task.wait() do
            if auto_collect then
                for _, v in next, pickables:GetChildren() do
                    if v:IsA("Model") then
                        local part = v:FindFirstChildWhichIsA("Part") or v:FindFirstChildWhichIsA("MeshPart")
                        if part then
                            local_player.Character.HumanoidRootPart.CFrame = part.CFrame
                            task.wait(collect_speed)
                        end
                    end
                end
            end

            if stop_at and local_player.PlayerGui.ScreenGui.HUD.Left.Currency.Gems.Frame.Max.Visible then
                library:Notify("Stopped AutoFarm Reached Max Gems")
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands.Zen.Island.Portal.Spawn")
                auto_collect = false
                break
            end
        end
    end
})

game_group:AddToggle('stop_at_max', {
    Text = 'Stop At Max Gems',
    Default = false,
    Tooltip = 'Stops Collecting At Max Gems',
    Callback = function(Value)
        stop_at = Value
    end
})
game_group:AddSlider('auto_collect_speed', {
    Text = 'Auto Collect Speed',
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        collect_speed = Value
    end
})

game_group:AddDivider()

game_group:AddToggle('auto_equip_best', {
    Text = 'Auto Equip Best',
    Default = false,
    Tooltip = 'Auto Equips Best Pets',
    Callback = function(Value)
        equip_best = Value
        while task.wait() do
            if equip_best then
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("EquipBestPets")
                task.wait(5)
            end
        end
    end
})

misc_group:AddToggle('auto_claim_playtime', {
    Text = 'Auto Claim Playtime Rewards',
    Default = false,
    Tooltip = 'Auto Claims Playtime Rewards',
    Callback = function(Value)
        claim_playtime = Value
        while task.wait(10) do
            if claim_playtime then
                for i = 1, 9 do
                    replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("ClaimPlaytime", i)
                    replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Function"):InvokeServer("ClaimPlaytime", i)
                    task.wait(1)
                end
            end
        end
    end
})

misc_group:AddToggle('auto_claim_tickets', {
    Text = 'Auto Claim Tickets',
    Default = false,
    Tooltip = 'Auto Claims Tickets',
    Callback = function(Value)
        claim_tickets = Value
        while task.wait(5) do
            if claim_tickets then
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("ClaimFreeWheelSpin")
            end
        end
    end
})

misc_group:AddToggle('auto_spin_wheel', {
    Text = 'Auto Spin Wheel',
    Default = false,
    Tooltip = 'Auto Spins Wheel',
    Callback = function(Value)
        spin_wheel = Value
        while task.wait(5) do
            if spin_wheel then
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Function"):InvokeServer("WheelSpin")
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("ClaimWheelSpinQueue")
            end
        end
    end
})

misc_group:AddToggle('auto_collect_chest', {
    Text = 'Auto Collect Chest',
    Default = false,
    Tooltip = 'Auto Collects Chest',
    Callback = function(Value)
        collect_chest = Value
        while task.wait(5) do
            if collect_chest then
                for _, v in next, chest:GetChildren() do
                    replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("ClaimChest", v.Name, true)
                end
            end
        end
    end
})

misc_group:AddToggle('auto_claim_seasonal', {
    Text = 'Auto Claim Season Rewards',
    Default = false,
    Tooltip = 'Auto Claims Season Rewards',
    Callback = function(Value)
        claim_seasonal = Value
        while task.wait(5) do
            if claim_seasonal then
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("ClaimSeason")
            end
        end
    end
})

misc_group:AddDivider()

misc_group:AddButton({
    Text = 'Get Free Legendary',
    Func = function()
        library:Notify('Claiming Legendary...')
        replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("FreeNotifyLegendary")
        library:Notify('Legendary Claimed!')
    end,
    DoubleClick = false,
    Tooltip = 'Claims Free Legendary Pet',
})

misc_group:AddButton({
    Text = 'Unlock islands',
    Func = function()
        for _, v in next, islands:GetDescendants() do
            if v.Name == "UnlockHitbox" then
                for i = 1, 5 do
                    firetouchinterest(local_player.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(local_player.Character.HumanoidRootPart, v, 1)
                    task.wait()
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Unlocks all islands',
})

auto_group:AddToggle('auto_open', {
    Text = 'Auto Open Chests',
    Default = false,
    Tooltip = 'Auto Opens Chests',
    Callback = function(Value)
        auto_open = Value
        while task.wait() do
            if auto_open then
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("UseGift", "Mystery Box", open_amount)
                task.wait(.1)
                for _, v in next, gifts:GetChildren() do
                    replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("ClaimGift", v.Name)
                    v:Destroy()
                end
            end
        end
    end
})

auto_group:AddSlider('auto_open_amount', {
    Text = 'Auto Open Chests Amount',
    Default = 10,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        open_amount = Value
    end
})

auto_group:AddDivider()

auto_group:AddToggle('auto_gold_orb', {
    Text = 'Auto Use Gold Orbs',
    Default = false,
    Tooltip = 'Auto Uses Gold Orbs',
    Callback = function(Value)
        auto_gold_orb = Value
        while task.wait() do
            if auto_gold_orb then
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("UseGoldenOrb")
                task.wait(900)
            end
        end
    end
})

auto_group:AddDivider()

auto_group:AddDropdown('potion_dropdown', {
    Values = potions,
    Default = "",
    Multi = false,

    Text = 'Potion Selector',
    Tooltip = 'Select a potion to use',

    Callback = function(Value)
        selected_potion = Value
    end
})

auto_group:AddDropdown('tier_dropdown', {
    Values = { 1, 2, 3, 4, 5, 6 },
    Default = 1,
    Multi = false,

    Text = 'Potion Tier Selector',
    Tooltip = 'Select a tier to use',

    Callback = function(Value)
        selected_potion_tier = Value
    end
})

auto_group:AddSlider('use_delay', {
    Text = 'Potion Use Delay',
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        potion_use_delay = Value
    end
})

auto_group:AddToggle('auto_potion', {
    Text = 'Auto Use Potions',
    Default = false,
    Tooltip = 'Auto Uses Potions',
    Callback = function(Value)
        auto_potion = Value
        while task.wait() do
            if auto_potion then
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("UsePotion", selected_potion, selected_potion_tier)
                library:Notify('Used ' .. selected_potion .. ' tier ' .. selected_potion_tier)
                task.wait(potion_use_delay)
            end
        end
    end
})

teleport_group:AddDropdown('island_selector', {
    Values = island_names,
    Default = "",
    Multi = false,

    Text = 'Island Selector',
    Tooltip = 'Select a island to teleport to',

    Callback = function(Value)
        selected_island = Value
    end
})

teleport_group:AddButton({
    Text = 'Teleport to selected island',
    Func = function()
        replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands." .. selected_island .. ".Island.Portal.Spawn")
        library:Notify('Teleported to ' .. selected_island)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports to selected island',
})

teleport_group:AddDivider()

teleport_group:AddButton({
    Text = 'Teleport to gift-rift',
    Func = function()
        local gift = rifts:FindFirstChild("gift-rift"):FindFirstChild("Display")
        if gift and rifts:FindFirstChild("gift-rift").Gift.Visual.Transparency == 0 then
            local position = Vector3.new(gift.Position.X, local_player.Character.HumanoidRootPart.Position.Y, gift.Position.Z)
            local current_tween = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new(10), {CFrame = CFrame.new(position)})
            current_tween:Play()
            current_tween.Completed:Wait()
            local_player.Character.HumanoidRootPart.CFrame = gift.CFrame
            library:Notify('Teleported to gift-rift')
        else
            library:Notify("Already Claimed")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports to gift rift',
})

teleport_group:AddButton({
    Text = 'Teleport to golden chest',
    Func = function()
        local golden_chest = workspace.Rendered.Rifts:FindFirstChild("golden-chest"):FindFirstChild("Display")
        if golden_chest then
            local position = Vector3.new(golden_chest.Position.X, local_player.Character.HumanoidRootPart.Position.Y, golden_chest.Position.Z)
            local current_tween = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new(10), {CFrame = CFrame.new(position)})
            current_tween:Play()
            current_tween.Completed:Wait()
            local_player.Character.HumanoidRootPart.CFrame = golden_chest.CFrame
            library:Notify('Teleported to golden chest')
        else
            library:Notify("Not Found")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports to golden chest',
})

minigames_group:AddToggle('auto_claim_doggy_jump', {
    Text = 'Auto Claim Doggy Jump Minigame',
    Default = false,
    Tooltip = 'Auto Claims Doggy Jump Minigame',
    Callback = function(Value)
        auto_doggy = Value
        while task.wait(5) do
            if auto_doggy then
                for i = 1, 3 do
                    replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("DoggyJumpWin", i)
                    task.wait()
                end
            end
        end
    end
})

enchant_group:AddLabel("Tutorial: Get the pet GUID using remote spy and go to enchantment table and select the pet you want to enchant and run it you cannot leave the enchant gui", true)

enchant_group:AddDropdown('enchant_selector', {
    Values = enchantments,
    Default = "",
    Multi = false,

    Text = 'Enchant Selector',
    Tooltip = 'Select an enchant to enchant your pet with',

    Callback = function(Value)
        selected_enchant = Value
    end
})

enchant_group:AddDropdown('enchant_method', {
    Values = { 'Reroll All', 'Reroll Slot' },
    Default = "Reroll All",
    Multi = false,

    Text = 'Enchant Method',
    Tooltip = 'Select an enchant method to use',

    Callback = function(Value)
        selected_enchant_method = Value
    end
})

enchant_group:AddDropdown('enchant_slot', {
    Values = { 1, 2 },
    Default = 1,
    Multi = false,

    Text = 'Enchant Slot',
    Tooltip = 'Select an enchant slot to enchant your pet with',

    Callback = function(Value)
        selected_enchant_slot = Value
    end
})

enchant_group:AddInput('pet_guid', {
    Default = 'Pet GUID Here',
    Numeric = false,
    Finished = true,

    Text = 'Insert Pet GUID Here',
    Tooltip = 'Put your pet guid here to enchant the selected pet',

    Placeholder = 'Skid Clan On Top!',

    Callback = function(Value)
        pet_guid = Value
        library:Notify('Changed to: ' .. pet_guid)
    end
})

enchant_group:AddToggle('auto_enchant', {
    Text = 'Auto Enchant Pet',
    Default = false,
    Tooltip = 'Auto Enchants Pet',
    Callback = function(Value)
        auto_enchant = Value
        if Value and pet_guid ~= "" and selected_enchant_method == "Reroll All" then
            repeat task.wait(.1)

                if local_player.PlayerGui.ScreenGui.Enchants.Frame.Inner.Details.Main.Enchants.Enchant1.Title.Text == selected_enchant or local_player.PlayerGui.ScreenGui.Enchants.Frame.Inner.Details.Main.Enchants.Enchant2.Title.Text == selected_enchant or not auto_enchant or not local_player.PlayerGui.ScreenGui.Enchants.Visible then
                    break
                end

                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Function"):InvokeServer("RerollEnchants", pet_guid)
            until local_player.PlayerGui.ScreenGui.Enchants.Frame.Inner.Details.Main.Enchants.Enchant1.Title.Text == selected_enchant or local_player.PlayerGui.ScreenGui.Enchants.Frame.Inner.Details.Main.Enchants.Enchant2.Title.Text == selected_enchant
            library:Notify("Got " .. selected_enchant)
        elseif selected_enchant_method == "Reroll Slot" and pet_guid ~= "" then
            repeat task.wait(.1)
                if local_player.PlayerGui.ScreenGui.Enchants.Frame.Inner.Details.Main.Enchants:FindFirstChild("Enchant" .. selected_enchant_slot) and local_player.PlayerGui.ScreenGui.Enchants.Frame.Inner.Details.Main.Enchants["Enchant" .. selected_enchant_slot].Title.Text == selected_enchant or local_player.PlayerGui.ScreenGui.Enchants.Frame.Tray.Orbs.Amount.Label.Text == 0 or not auto_enchant or not local_player.PlayerGui.ScreenGui.Enchants.Visible then
                    break
                end
        
                replicated_storage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("RerollEnchant", pet_guid, selected_enchant_slot)
            until local_player.PlayerGui.ScreenGui.Enchants.Frame.Inner.Details.Main.Enchants:FindFirstChild("Enchant" .. selected_enchant_slot) and local_player.PlayerGui.ScreenGui.Enchants.Frame.Inner.Details.Main.Enchants["Enchant" .. selected_enchant_slot].Title.Text == selected_enchant
            library:Notify("Got " .. selected_enchant)
        end
    end
})

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
    claim_playtime = false
    claim_seasonal = false
    auto_gold_orb = false
    collect_chest = false
    claim_tickets = false
    auto_collect = false
    auto_enchant = false
    auto_potion = false
    spin_wheel = false
    equip_best = false
    auto_doggy = false
    auto_open = false
    auto_blow = false
    auto_sell = false
    stop_at = false
    connections:Disconnect()
    watermark_connection:Disconnect()
    library:Unload()
end)

settings_group:AddToggle('keybind_visibility', {
    Text = 'Keybind Visibility',
    Default = false,
    Tooltip = 'Enables/Disables the watermark',

    Callback = function(Value)
        library.KeybindFrame.Visible = Value
    end,
})

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
