local rape = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Lib = loadstring(game:HttpGet(rape .. 'Library.lua'))()

local instance = game.PlaceId
local Market = game:GetService("MarketplaceService")
local info = Market:GetProductInfo(instance)

if instance == 78360449985300 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/Disch.lua"))()
else
    Lib:Notify('Game not supported: ' .. info.Name)
    Lib:Notify('Copied Discord to your clipboard')
    setclipboard('https://discord.gg/frQv5QScXS')
end

if instance == game.PlaceId then
    Lib:Notify('Supported! loading: ' .. info.Name)
end
