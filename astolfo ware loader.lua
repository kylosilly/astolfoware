local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Lib = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local instance = game.PlaceId
local market = game:GetService("MarketplaceService")
local instanceinfo = market:GetProductInfo(instance)

if instance == 78360449985300 then --// Disch
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/scripts/Disch.lua"))()
elseif instance == 4483381587 then --// a literal baseplate.
    print("test")
else
    Lib:Notify('Game not found. If you want it to be supported, send this to the owner: ' .. instanceinfo.Name)
    Lib:Notify('Copied Discord to your clipboard')
    setclipboard('https://discord.gg/frQv5QScXS')
end
