--// Feel free to use this loader source 🐾 <3
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/ChatTag.lua"))()

local Lib = loadstring(game:HttpGet(repo .. 'Library.lua'))()

--// Services
local Chart = game.PlaceId
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(Chart)
local LocalPlayer = game:GetService("Players").LocalPlayer

if identifyexecutor() then
    local executor = identifyexecutor()
    if executor == "Solara" or executor == "Xeno" or executor == "Nezur" then
        LocalPlayer:Kick("Unsupported executor: " .. executor .. " Please use Velocity or a diffirent one (Copied velocity invite to your clipboard")
        setclipboard("https://discord.gg/getvelocity")
    end
end

if Chart == 78360449985300 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/Disch.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
elseif Chart == 116495829188952 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/DeadRailLobby.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
elseif Chart == 70876832253163 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/DeadRailGame.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
elseif Info.Name == "[🐍 LUNAR YEAR] Horrific Housing" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/Horrific%20Housing.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
elseif Info.Name == "SPECTER Classic [AI]" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/Specter.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
else
    Lib:Notify('Game not supported: ' .. Info.Name)
end
