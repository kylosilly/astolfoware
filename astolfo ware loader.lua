--// Feel free to use this loader source 🐾 <3
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/ChatTag.lua"))()

local Lib = loadstring(game:HttpGet(repo .. 'Library.lua'))()

--// Services
local Chart = game.PlaceId
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(Chart)

setclipboard('https://discord.gg/frQv5QScXS')
Lib:Notify('Copied discord link to your clipboard')

if Chart == 78360449985300 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/Disch.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
elseif Chart == 116495829188952 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/DeadRailLobby.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
elseif Chart == 70876832253163 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/DeadRailGame.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
else
    Lib:Notify('Game not supported: ' .. Info.Name)
end
