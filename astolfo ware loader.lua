--// Feel free to use this loader source 🐾 <3
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Lib = loadstring(game:HttpGet(repo .. 'Library.lua'))()

--// Services
local Chart = game.PlaceId
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(Chart)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Tables
local Friends = {1660649535, 873084588, 1740785260, 608503596}
local Developer = {1412075257, 12967961, 7187968387}
local BigRat = 7060863999
local Testers = 573649346

setclipboard('https://discord.gg/frQv5QScXS')
Lib:Notify('Copied discord link to your clipboard')

if Chart == 78360449985300 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/Disch.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
else
    Lib:Notify('Game not supported: ' .. Info.Name)
end

--// Thanks ! nfpw for fixing this <3
function RoleCheck(Player)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then local Humanoid = Player.Character:FindFirstChild("Humanoid")
        if table.find(Friends, Player.UserId) then
            Humanoid.DisplayName = " [Friend] "..Player.DisplayName
        elseif table.find(Developer, Player.UserId) then
            Humanoid.DisplayName = " [Developer] "..Player.DisplayName
        elseif Player.UserId == BigRat then
            Humanoid.DisplayName = "🐀 [Big Rat] "..Player.DisplayName
        elseif Player.UserId == Testers then
            Humanoid.DisplayName = "🧪 [Tester] "..Player.DisplayName
        end
    end
end

for _, p in pairs(Players:GetPlayers()) do RoleCheck(p) end; Players.PlayerAdded:Connect(function(Player) RoleCheck(Player); Player.CharacterAdded:Connect(function() RoleCheck(Player) end) end)
