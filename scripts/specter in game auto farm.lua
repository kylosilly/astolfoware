if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded")
end

task.wait(7)

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

library:Notify("Running Script, sit back and relax :3")
library:Notify("Once the auto farm is finished please check console for the evidences")

local proximitry_prompt_service = game:GetService("ProximityPromptService")
local virtual_input_manager = game:GetService("VirtualInputManager")
local replicated_storage = game:GetService("ReplicatedStorage")
local text_chat_service = game:GetService("TextChatService")
local local_player = game:GetService("Players").LocalPlayer
local teleport_service = game:GetService("TeleportService")
local run_service = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local camera = workspace.CurrentCamera

local fingerprints_folder = workspace.Dynamic.Evidence.Fingerprints
local motions_folder = workspace.Dynamic.Evidence.MotionGrids -- for checking if ghost touches
local motion_grid = workspace.Dynamic.Evidence.MotionGrids -- for tping it to ghost
local orbs_folder = workspace.Dynamic.Evidence.Orbs
local emf_folder = workspace.Dynamic.Evidence.EMF

local van_equipment = workspace.Van.Equipment
local van_button = workspace.Van.Close
local van = workspace.Van

local map = workspace:FindFirstChild("Map")
local rooms = map.Rooms

local checked_spirit_box = false
local check_fingerprint = true
local checked_freezing = false
local checked_motion = false
local collected_bone = false
local checked_info = false
local got_room = false
local check_orb = true
local check_emf = true

local started_round = false
local collected_equipment = false

local ghost_room = nil

lighting.ClockTime = 12
lighting.GlobalShadows = false

proximitry_prompt_service.PromptButtonHoldBegan:Connect(function(prompt)
    prompt.HoldDuration = 0
end)

emf_folder.ChildAdded:Connect(function(emf)
    if emf.Name == "EMF5" and check_emf then
        library:Notify("Found EMF 5")
        print("Found EMF 5")
        check_emf = false
    end
end)

fingerprints_folder.ChildAdded:Connect(function(fingerprint)
    if fingerprint:IsA("Part") and check_fingerprint then
        library:Notify("Found Fingerprints")
        print("Found Fingerprint")
        check_fingerprint = false
    end
end)

orbs_folder.ChildAdded:Connect(function(orb)
    if orb:IsA("Part") and check_orb then
        library:Notify("Found Orbs")
        print("Found Orbs")
        check_orb = false
    end
end)

motion_connection = run_service.RenderStepped:Connect(function()
    for _, motion in pairs(motion_grid:GetDescendants()) do
        if motion:IsA("Part") then
            if motion.Color == Color3.fromRGB(252, 52, 52) then
                library:Notify("Found Motion")
                print("Found Motion")
                checked_motion = true
                motion_connection:Disconnect()
                break
            elseif motion.BrickColor == BrickColor.new("Toothpaste") then
                library:Notify("No Motion")
                print("No Motion")
                checked_motion = true
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
        print("Evidences:")
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
        task.wait(0.25)
        fireproximityprompt(bone_prompt)
        task.wait(0.25)
        local_player.Character.HumanoidRootPart.CFrame = last_pos
        collected_bone = true
        library:Notify("Collected Bone")
    else
        library:Notify("No Bone Found, Skipping")
        collected_bone = true
    end
end

if collected_bone then
    local last_pos = local_player.Character.HumanoidRootPart.CFrame
    local van_prompt = van_button:FindFirstChildOfClass("ProximityPrompt")

    if van_prompt then
        local_player.Character.HumanoidRootPart.CFrame = van_prompt.Parent.CFrame + Vector3.new(3, 0, 0)
        task.wait(1)
        fireproximityprompt(van_prompt)
        task.wait(1)
        local_player.Character.HumanoidRootPart.CFrame = last_pos
        library:Notify("Started Game")
        started_round = true
    end
end

task.wait()

if started_round then
    local last_pos = local_player.Character.HumanoidRootPart.CFrame

    for _, equipment in pairs(van_equipment:GetChildren()) do
        if equipment:IsA("Model") and (equipment.Name == "EMF Reader" or equipment.Name == "Thermometer" or equipment.Name == "Spirit Box") then
            local_player.Character.HumanoidRootPart.CFrame = equipment.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("PickupItem"):InvokeServer(equipment)
            local_player.Character.HumanoidRootPart.CFrame = last_pos
            collected_equipment = true
        end
    end

    if not collected_equipment then
        local_player:kick("Equipment not found! please report this to @kylosilly on discord!")
        wait(1)
        teleport_service:Teleport(8267733039)
    end

    if collected_equipment then
        local last_pos = local_player.Character.HumanoidRootPart.CFrame
        virtual_input_manager:SendKeyEvent(true, Enum.KeyCode.Two, false, nil)

        task.wait(.25)

        local emf_tool = local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("2")
        local emf = local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("1")

        if not emf_tool then
            local_player:kick("EMF tool not found! please report this to @kylosilly on discord!")
            wait(1)
            teleport_service:Teleport(8267733039)
        end

        if not emf or emf.Color ~= Color3.fromRGB(52, 142, 64) then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Toggle"):InvokeServer("EMF Reader")
        end

        for _, room in pairs(rooms:GetChildren()) do
            if room:IsA("Folder") then
                local hitbox = room:FindFirstChild("Hitbox")

                if hitbox then
                    local_player.Character.HumanoidRootPart.CFrame = hitbox.CFrame
                    camera.CFrame = hitbox.CFrame
                    task.wait(.75)

                    if emf_tool.Color == Color3.fromRGB(131, 156, 49) then
                        ghost_room = hitbox.CFrame
                        got_room = true
                        library:Notify("Got ghost room: " .. room.Name .. " (It Not Might Be Always The Ghost Room!)")
                        local_player.Character.HumanoidRootPart.CFrame = last_pos
                        break
                    end
                end
            end
        end

        if not got_room then
            task.wait(.75)
            library:Notify("Ghost room not found retrying...")
            for _, room in pairs(rooms:GetChildren()) do
                if room:IsA("Folder") then
                    local hitbox = room:FindFirstChild("Hitbox")

                    if hitbox then
                        local_player.Character.HumanoidRootPart.CFrame = hitbox.CFrame
                        camera.CFrame = hitbox.CFrame
                        task.wait(.75)

                        if emf_tool.Color == Color3.fromRGB(131, 156, 49) then
                            ghost_room = hitbox.CFrame
                            got_room = true
                            library:Notify("Got ghost room: " .. room.Name .. " (It Not Might Be Always The Ghost Room!)")
                            local_player.Character.HumanoidRootPart.CFrame = last_pos
                            break
                        end
                    end
                end    
            end

            if not got_room then
                replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Drop"):InvokeServer(2)
                for _, equipment in pairs(van_equipment:GetChildren()) do
                    if equipment:IsA("Model") and equipment.Name == "Motion Sensor" then
                        local_player.Character.HumanoidRootPart.CFrame = equipment.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("PickupItem"):InvokeServer(equipment)
                        task.wait(.25)
                        for _, room in pairs(rooms:GetChildren()) do
                            if room:IsA("Folder") then
                                local hitbox = room:FindFirstChild("Hitbox")

                                if hitbox then
                                    for i = 1, 2 do
                                        local_player.Character.HumanoidRootPart.CFrame = hitbox.CFrame
                                        task.wait()
                                    end

                                    local last_pos = {}

                                    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + Vector3.new(1, -1.5, 0))
                                    task.wait(0.75)
                                    mouse1click()
                                end

                                task.wait(5)

                                local_player.Character.HumanoidRootPart.CFrame = van.PrimaryPart.CFrame + Vector3.new(0, 3, 0)

                                if not motion_grid then
                                    library:Notify("Motion Grids not found place one before using this feature!")
                                    wait(1)
                                    teleport_service:Teleport(8267733039)
                                end

                                task.wait(9)

                                if motion_grid then
                                    for _, motion_grids in pairs(motion_grid:GetDescendants()) do
                                        if motion_grids:IsA("Part") then
                                            last_pos[motion_grids] = motion_grids.CFrame
                                            local ghost = workspace.NPCs:FindFirstChildOfClass("Model")
                                            motion_grids.CFrame = ghost.HumanoidRootPart.CFrame + Vector3.new(1, 0, 0)
                                        end
                                    end

                                    task.wait()

                                    for v, pos in pairs(last_pos) do
                                        v.CFrame = pos
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        library:Notify("Waiting a few secounds for the ghost to chill to prevent hunts")
        task.wait(10)

        if got_room then
            virtual_input_manager:SendKeyEvent(true, Enum.KeyCode.One, false, nil)

            task.wait(.25)

            local thermometer = local_player.Character and local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("Temp") and local_player.Character.EquipmentModel.Temp:FindFirstChild("SurfaceGui") and local_player.Character.EquipmentModel.Temp.SurfaceGui:FindFirstChild("TextLabel")

            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Toggle"):InvokeServer("Thermometer")

            if not thermometer then
                local_player:Kick("Thermometer not found! please report this to @kylosilly on discord!")
            end

            if thermometer then
                local_player.Character.HumanoidRootPart.CFrame = ghost_room
                task.wait(8)

                local Temperature = tonumber(thermometer.Text:match("[-%d]+"))

                if Temperature and Temperature < 0 then
                    library:Notify("Got Freezing Temperature")
                    print("Got Freezing Temperature")
                    checked_freezing = true
                else
                    library:Notify("No Freezing Temperature")
                    print("No Freezing Temperature")
                    checked_freezing = true
                end
            end
        end

        if checked_freezing then
            virtual_input_manager:SendKeyEvent(true, Enum.KeyCode.Three, false, nil)

            task.wait(.25)

            local spirit_box = local_player.Character and local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("Main")
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Toggle"):InvokeServer("Spirit Box")

            if not spirit_box then
                local_player:Kick("Spirit box not found! please report this to @kylosilly on discord!")
                wait(1)
                teleport_service:Teleport(8267733039)
            end

            if spirit_box then
                local responses
                responses = spirit_box.DescendantAdded:Connect(function(reply)

                    if reply:IsA("BillboardGui") then
                        local_player.Character.HumanoidRootPart.CFrame = van.PrimaryPart.CFrame
                        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Drop"):InvokeServer(3)
                        library:Notify("Got Spirit Box")
                        print("Got Spirit Box")
                        checked_spirit_box = true
                        responses:Disconnect()
                    end
                end)

                for i = 1, 12 do
                    text_chat_service:FindFirstChild("TextChannels").RBXGeneral:SendAsync("Where are you?")
                    task.wait(.5)

                    if checked_spirit_box then
                        break
                    end
                end

                if not checked_spirit_box then
                    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Drop"):InvokeServer(3)
                    library:Notify("No Spirit Box")
                    print("No Spirit Box")
                    checked_spirit_box = true
                end
            end
        end

        if checked_spirit_box then
            local last_pos = {}

            for _, equipment in pairs(van_equipment:GetChildren()) do
                if equipment:IsA("Model") and equipment.Name == "Motion Sensor" then
                    local_player.Character.HumanoidRootPart.CFrame = equipment.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("PickupItem"):InvokeServer(equipment)
                    local_player.Character.HumanoidRootPart.CFrame = ghost_room
                    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + Vector3.new(1, -1.5, 0))
                    task.wait(0.75)
                    mouse1click()
                end
            end

            task.wait(5)

            local_player.Character.HumanoidRootPart.CFrame = van.PrimaryPart.CFrame + Vector3.new(0, 3, 0)

            if not motion_grid then
                local_player:Kick("Motion grid not found! please report this to @kylosilly on discord!")
                wait(1)
                teleport_service:Teleport(8267733039)
            end

            task.wait(9)

            for _, motion_grids in pairs(motion_grid:GetDescendants()) do
                if motion_grids:IsA("Part") then
                    last_pos[motion_grids] = motion_grids.CFrame
                    local ghost = workspace.NPCs:FindFirstChildOfClass("Model")
                    motion_grids.CFrame = ghost.HumanoidRootPart.CFrame + Vector3.new(1, 0, 0)
                end
            end

            task.wait()

            for v, pos in pairs(last_pos) do
                v.CFrame = pos
            end
        end
    end
end
