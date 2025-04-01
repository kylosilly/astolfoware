if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded")
end

task.wait(5)

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

local Version = "V1.5.0"

library:Notify("Loaded Auto Farm. Current Version: " .. Version)
library:Notify("Auto Farm Made By @kylosilly On Discord <3")

--// Services

local virtual_input_manager = game:GetService("VirtualInputManager")
local replicated_storage = game:GetService("ReplicatedStorage")
local text_chat_service = game:GetService("TextChatService")
local local_player = game:GetService("Players").LocalPlayer
local teleport_service = game:GetService("TeleportService")
local run_service = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local camera = workspace.CurrentCamera

--// Paths

local fingerprints_folder = workspace.Dynamic.Evidence.Fingerprints
local motions_folder = workspace.Dynamic.Evidence.MotionGrids
local orbs_folder = workspace.Dynamic.Evidence.Orbs
local emf_folder = workspace.Dynamic.Evidence.EMF

local sinks = workspace.Map.EventObjects.Sinks

local van_equipment = workspace.Van.Equipment
local van_button = workspace.Van.Close
local van = workspace.Van

local map = workspace:FindFirstChild("Map")
local rooms = map.Rooms

--// Variables

local got_fingerprint = false
local got_spirit_box = false
local got_emf_five = false
local got_freezing = false
local no_freezing = false
local got_writing = false
local no_writing = false
local got_motion = false
local got_orb = false

local collected_equipment = false
local collected_bone = false
local started_round = false

local check_fingerprint = true
local check_info = true
local check_emf = true
local check_orb = true
local got_room = false

local ghost_room = nil
local room_name = nil

--// Main Script (Dont Modify Anything Under Here Unless You Know What Youre Doing)

if not hookmetamethod then
    local_player:Kick("Your Executor Dosent Support HookMetaMethod")
end

lighting.ClockTime = 12
lighting.GlobalShadows = false

emf_folder.ChildAdded:Connect(function(emf)
    if emf.Name == "EMF5" and check_emf then
        library:Notify("Found EMF5")
        print("Got EMF5")
        got_emf_five = true
        check_emf = false
    end
end)

fingerprints_folder.ChildAdded:Connect(function(fingerprint)
    if fingerprint:IsA("Part") and check_fingerprint then
        library:Notify("Found Fingerprint")
        print("Got Fingerprint")
        got_fingerprint = true
        check_fingerprint = false
    end
end)

orbs_folder.ChildAdded:Connect(function(orb)
    if orb:IsA("Part") and check_orb then
        library:Notify("Found Orbs")
        print("Got Orbs")
        got_orb = true
        check_orb = false
    end
end)

motion_connection = run_service.RenderStepped:Connect(function()
    for _, motion in pairs(motions_folder:GetDescendants()) do
        if motion:IsA("Part") then
            if motion.Color == Color3.fromRGB(252, 52, 52) then
                library:Notify("Found Motion")
                print("Found Motion")
                got_motion = true
                motion_connection:Disconnect()
                break
            elseif motion.BrickColor == BrickColor.new("Toothpaste") then
                library:Notify("No Motion")
                print("No Motion")
                no_motion = true
                motion_connection:Disconnect()
                break
            end
        end
    end
end)

virtual_input_manager:SendKeyEvent(true, Enum.KeyCode.One, false, nil)
replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Drop"):InvokeServer(1)

if local_player then
    local device = local_player:GetAttribute("Device")
    local gid = local_player:GetAttribute("GID")
    local join_time = local_player:GetAttribute("Join")

    if device and gid and join_time then
        print"Semi Auto Farm Script Made By @kylosilly On Discord <3"
        print"------------------------------------------------------"
        print("Debug Info Ignore This!")
        print("Device: " .. device)
        print("LocalPlayer GID: " .. gid)
        print("Join Time: " .. os.date("%Y-%m-%d %H:%M:%S", join_time))
        print"------------------------------------------------------"
        checked_info = true
    end
elseif not checked_info then
    local_player:kick("Couldnt get attributes of localplayer please report this to @kylosilly on discord!")
    wait(1)
    teleport_service:Teleport(8267733039)
end

if checked_info then
    local bone = map:FindFirstChild("Bone")

    if bone then
        local bone_prompt = bone:FindFirstChildOfClass("ProximityPrompt")
        local last_pos = local_player.Character.HumanoidRootPart.CFrame

        local_player.Character.HumanoidRootPart.CFrame = bone.CFrame + Vector3.new(0, 5, 0)
        task.wait(.5)
        fireproximityprompt(bone_prompt)
        task.wait(.5)
        local_player.Character.HumanoidRootPart.CFrame = last_pos
        library:Notify("Collected Bone")
        collected_bone = true
    else
        library:Notify("No Bone Found, Skipping")
        collected_bone = true
    end
end

task.wait(5)

if collected_bone then
    local last_pos = local_player.Character.HumanoidRootPart.CFrame
    local van_prompt = van_button:FindFirstChildOfClass("ProximityPrompt")

    if van_prompt then
        local_player.Character.HumanoidRootPart.CFrame = van_prompt.Parent.CFrame + Vector3.new(3, 0, 0)
        camera.CFrame = van_prompt.Parent.CFrame
        task.wait(1)
        fireproximityprompt(van_prompt)
        task.wait(1)
        local_player.Character.HumanoidRootPart.CFrame = last_pos
        started_round = true
    end
end

task.wait(10)

if started_round then
    for _, equipment in next, van_equipment:GetChildren() do
        if equipment:IsA("Model") and (equipment.Name == "EMF Reader" or equipment.Name == "Thermometer" or equipment.Name == "Spirit Box") then
            local_player.Character.HumanoidRootPart.CFrame = equipment.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("PickupItem"):InvokeServer(equipment)
            collected_equipment = true
        end
    end

    if not collected_equipment then
        local_player:kick("Equipment not found! please report this to @kylosilly on discord!")
        wait(1)
        teleport_service:Teleport(8267733039)
    end

    if collected_equipment then
        virtual_input_manager:SendKeyEvent(true, Enum.KeyCode.Two, false, nil)
        task.wait(.25)
        local emf_tool = local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("2")
        local emf = local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("1")

        if not emf_tool then
            local_player:kick("EMF tool not found! please report this to @kylosilly on discord!")
            wait(2.5)
            teleport_service:Teleport(8267733039)
        end

        if not emf or emf.Color ~= Color3.fromRGB(52, 142, 64) then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Toggle"):InvokeServer("EMF Reader")
        end

        for _, room in next, rooms:GetChildren() do
            if room:IsA("Folder") then
                local hitbox = room:FindFirstChild("Hitbox")

                if hitbox then
                    local_player.Character.HumanoidRootPart.CFrame = hitbox.CFrame
                    camera.CFrame = hitbox.CFrame
                    task.wait(.75)

                    if emf_tool.Color == Color3.fromRGB(131, 156, 49) then
                        ghost_room = hitbox.CFrame
                        room_name = room.Name
                        got_room = true
                        library:Notify("Got ghost room: " .. room.Name .. " (It Not Might Be Always The Ghost Room!)")
                        break
                    end
                end
            end
        end

        if not got_room then
            local_player:kick("Ghost room not found! please report this to @kylosilly on discord!")
            wait(1)
            teleport_service:Teleport(8267733039)
        end
    end

    if got_room then
        if hookmetamethod then
            library:Notify("Hooking LocalPlayer Room Value To Ghost Room...")
            local old
            old = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
    
                if method == "InvokeServer" and self.Name == "UpdateRoom" and not checkcaller() then
                    args[1] = room_name
                    return old(self, unpack(args))
                end
                return old(self, ...)
            end)
        end    

        virtual_input_manager:SendKeyEvent(true, Enum.KeyCode.One, false, nil)
        task.wait(.25)
        local thermometer = local_player.Character and local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("Temp") and local_player.Character.EquipmentModel.Temp:FindFirstChild("SurfaceGui") and local_player.Character.EquipmentModel.Temp.SurfaceGui:FindFirstChild("TextLabel")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Toggle"):InvokeServer("Thermometer")

        if not thermometer then
            local_player:Kick("Thermometer not found! please report this to @kylosilly on discord!")
            wait(2.5)
            teleport_service:Teleport(8267733039)
        end

        if thermometer then
            local_player.Character.HumanoidRootPart.CFrame = ghost_room
            task.wait(8)
            local temperature = tonumber(thermometer.Text:match("[-%d]+"))

            
            if temperature and temperature < 0 then
                library:Notify("Got Freezing Temperature")
                print("Got Freezing Temperature")
                got_freezing = true
            else
                library:Notify("No Freezing Temperature")
                print("No Freezing Temperature")
                no_freezing = true
            end
        end
    end

    if (got_freezing or no_freezing) then
        virtual_input_manager:SendKeyEvent(true, Enum.KeyCode.Three, false, nil)
        task.wait(.25)
        local spirit_box = local_player.Character and local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("Main")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Toggle"):InvokeServer("Spirit Box")

        if not spirit_box then
            local_player:Kick("Spirit box not found! please report this to @kylosilly on discord!")
            wait(2.5)
            teleport_service:Teleport(8267733039)
        end

        if spirit_box then
            local responses
            responses = spirit_box.DescendantAdded:Connect(function(reply)
                if reply:IsA("BillboardGui") then
                    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Drop"):InvokeServer(3)
                    responses:Disconnect()
                    got_spirit_box = true
                    library:Notify("Got Spirit Box")
                    print("Got Spirit Box")
                end
            end)

            for i = 1, 15 do
                text_chat_service:FindFirstChild("TextChannels").RBXGeneral:SendAsync("Where are you?")
                task.wait(.5)

                if got_spirit_box then
                    break
                end
            end

            if not got_spirit_box then
                replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Drop"):InvokeServer(3)
                library:Notify("No Spirit Box")
                print("No Spirit Box")
            end
        end
    end

    if (got_spirit_box or not got_spirit_box) then
        local last_pos = {}

        for _, equipment in pairs(van_equipment:GetChildren()) do
            if equipment:IsA("Model") and equipment.Name == "Motion Sensor" then
                local_player.Character.HumanoidRootPart.CFrame = equipment.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("PickupItem"):InvokeServer(equipment)
                local_player.Character.HumanoidRootPart.CFrame = ghost_room
                camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + Vector3.new(1, -2.5, 0))
                task.wait(.75)
                mouse1click()
                task.wait(.1)
                local_player.Character.HumanoidRootPart.CFrame = van.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            end
        end

        task.wait(5)

        if not motions_folder then
            local_player:Kick("Motion sensor not found! please report this to @kylosilly on discord!")
            wait(2.5)
            teleport_service:Teleport(8267733039)
        end

        task.wait(8)

        for _, motion_grid in pairs(motions_folder:GetDescendants()) do
            if motion_grid:IsA("Part") then
                last_pos[motion_grid] = motion_grid.CFrame
                local ghost = workspace.NPCs:FindFirstChildOfClass("Model")
                motion_grid.CFrame = ghost.HumanoidRootPart.CFrame + Vector3.new(1, 0, 0)
            end
        end

        task.wait(1)

        for v, pos in pairs(last_pos) do
            v.CFrame = pos
        end
    end

    task.wait(1)
    for _, equipment in pairs(van_equipment:GetChildren()) do
        if equipment:IsA("Model") and equipment.Name == "Book" then
            local_player.Character.HumanoidRootPart.CFrame = equipment.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("PickupItem"):InvokeServer(equipment)
            local_player.Character.HumanoidRootPart.CFrame = ghost_room
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + Vector3.new(-1, -2.5, 0))
            task.wait(.75)
            mouse1click()
            task.wait(.1)

            local book = workspace.Equipment.Book
            local_player.Character.HumanoidRootPart.CFrame = CFrame.new(-223, 166, -213)

            if not book then
                local_player:Kick("Book not found! please report this to @kylosilly on discord!")
                wait(2.5)
                teleport_service:Teleport(8267733039)
            end

            task.wait(60)

            if book:FindFirstChild("LeftPage") and book.LeftPage:FindFirstChildOfClass("Decal") and book:FindFirstChild("RightPage") and book.RightPage:FindFirstChildOfClass("Decal") then
                library:Notify("Found Writing")
                print("Got Writing")
                got_writing = true
            else
                library:Notify("No Writing")
                print("No Writing")
                no_writing = true
            end
        end
    end

    library:Notify("Waiting 20 More Seconds For Sink To Get Dirty Water Or Waiting For Evidence To Spawn...")
    task.wait(20)

    for _, sink in next, sinks:GetChildren() do
        if sink.Transparency < 1 then
            library:Notify("Found Dirty Water In Sink")
            local sink_prompt = sink:FindFirstChildOfClass("ProximityPrompt")
            local_player.Character.HumanoidRootPart.CFrame = sink_prompt.Parent.CFrame
            task.wait(0.5)
            fireproximityprompt(sink_prompt)
            task.wait(0.5)
            local_player.Character.HumanoidRootPart.CFrame = van.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
        end
    end

    if got_emf_five and got_fingerprint and got_freezing then
        library:Notify("Ghost is: Banshee")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Banshee")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_freezing and got_spirit_box and got_orb then
        library:Notify("Ghost is: Mare")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Mare")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_motion and got_spirit_box and got_freezing then
        library:Notify("Ghost is: Wendigo")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Wendigo")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_spirit_box and got_fingerprint and got_orb then
        library:Notify("Ghost is: Poltergeist")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Poltergeist")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_freezing and got_orb and got_emf_five then
        library:Notify("Ghost is: Phantom")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Phantom")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_emf_five and got_motion and got_orb then
        library:Notify("Ghost is: Jinn")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Jinn")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_emf_five and got_freezing and got_motion then
        library:Notify("Ghost is: Upyr")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Upyr")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_emf_five and got_fingerprint and got_spirit_box then
        library:Notify("Ghost is: Aswang")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Aswang")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_orb and got_fingerprint and got_freezing then
        library:Notify("Ghost is: Thaye")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Thaye")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_emf_five and got_fingerprint and got_orb then
        library:Notify("Ghost is: O Tokata")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("O Tokata")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_motion and got_emf_five and got_spirit_box then
        library:Notify("Ghost is: Myling")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Myling")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_motion and got_freezing and got_orb then
        library:Notify("Ghost is: Afarit")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Afarit")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_motion and got_emf_five and got_fingerprint then
        library:Notify("Ghost is: Preta")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Preta")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_motion and got_freezing and got_fingerprint then
        library:Notify("Ghost is: Yokai")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Yokai")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_writing and got_spirit_box and got_freezing then
        library:Notify("Ghost is: Demon")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Demon")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_writing and got_fingerprint and got_spirit_box then
        library:Notify("Ghost is: Spirit")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Spirit")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_emf_five and got_writing and got_fingerprint then
        library:Notify("Ghost is: Revenant")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Revenant")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_emf_five and got_writing and got_orb then
        library:Notify("Ghost is: Shade")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Shade")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_freezing and got_writing and got_orb then
        library:Notify("Ghost is: Yurei")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Yurei")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_motion and got_writing and got_spirit_box then
        library:Notify("Ghost is: Oni")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Oni")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_orb and got_writing and got_spirit_box then
        library:Notify("Ghost is: Egui")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Egui")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_orb and got_fingerprint and got_writing then
        library:Notify("Ghost is: Wisp")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Wisp")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_motion and got_fingerprint and got_writing then
        library:Notify("Ghost is: Douen")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Douen")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_motion and got_writing and got_emf_five then
        library:Notify("Ghost is: Douen")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Douen")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_spirit_box and got_writing and got_emf_five then
        library:Notify("Ghost is: Mimic")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Mimic")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    elseif got_motion and got_writing and got_freezing then
        library:Notify("Ghost is: Bhuta")
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("UpdateGuess"):InvokeServer("Bhuta")
        local_player.Character.HumanoidRootPart.CFrame = van_button.CFrame
        task.wait(0.25)
        fireproximityprompt(van_button:FindFirstChildOfClass("ProximityPrompt"))
    else
        library:Notify("Couldnt Guess Ghost As It Lacks Evidence")
    end
end
