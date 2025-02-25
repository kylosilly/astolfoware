local rape = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Lib = loadstring(game:HttpGet(rape .. 'Library.lua'))()

local Instance = game.PlaceId
local Market = game:GetService("MarketplaceService")
local Info = Market:GetProductInfo(Instance)

if Instance == 78360449985300 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/Disch.lua"))()
else
    Lib:Notify('Game not supported: ' .. Info.Name)
end

if Instance == game.PlaceId then
    Lib:Notify('Supported! loading: ' .. Info.Name)
end
