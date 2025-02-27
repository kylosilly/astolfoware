local rape = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Lib = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local Chart = game.PlaceId
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(Chart)

setclipboard('https://discord.gg/frQv5QScXS')
Lib:Notify('Copied discord link to your clipboard')

if Chart == 78360449985300 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/Disch.lua"))()
    Lib:Notify('Supported! loading: ' .. Info.Name)
else
    Lib:Notify('Game not supported: ' .. Info.Name)
end
