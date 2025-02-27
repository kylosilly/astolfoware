local Players = game:GetService("Players")
local CharacterAddedConnections = {}

local Friends = {1660649535, 873084588, 1740785260, 608503596}
local Developer = {1412075257, 12967961}
local BigRat = 7060863999
local Testers = 573649346

function RoleCheck(Player)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") ~= nil then
        local Humanoid = Player.Character.Humanoid
        if table.find(Friends, Player.UserId) then
            Humanoid.DisplayName = " [Friend] "..Player.DisplayName
        elseif table.find(Developer, Player.UserId) then
            Humanoid.DisplayName = " [Script Developer] "..Player.DisplayName
        elseif Player.UserId == BigRat then
            Humanoid.DisplayName = "🐀 [Big Rat] "..Player.DisplayName
        elseif Player.UserId == Testers then
            Humanoid.DisplayName = "🧪 [Tester] "..Player.DisplayName
        end
    end
end

for _, p in pairs(Players:GetPlayers()) do if p.Character then RoleCheck(p) end if not CharacterAddedConnections[p] then CharacterAddedConnections[p] = p.CharacterAdded:Connect(function(char) task.wait(0.05) RoleCheck(p) end) end end Players.PlayerAdded:Connect(function(Player) CharacterAddedConnections[Player] = Player.CharacterAdded:Connect(function(char) task.wait(0.05) RoleCheck(Player) end) end) Players.PlayerRemoving:Connect(function(Player) if CharacterAddedConnections[Player] then CharacterAddedConnections[Player]:Disconnect() CharacterAddedConnections[Player] = nil end end)
