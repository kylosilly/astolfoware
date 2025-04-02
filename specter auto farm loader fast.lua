--// This Is Version V1.7.0 Of The Auto Farm. Please Report Bugs To @kylosilly On Discord

local scripts = 'https://raw.githubusercontent.com/kylosilly/astolfoware/main/scripts/'

local market = game:GetService("MarketplaceService")
local info = market:GetProductInfo(game.PlaceId)
local place_id = game.PlaceId

if place_id == 8267733039 then
    loadstring(game:HttpGet(scripts.."specter%20lobby%20auto%20farm.lua"))()
elseif info.Name == "SPECTER Classic [AI]" then
    loadstring(game:HttpGet(scripts.."specter%20auto%20farm%20in%20game%20fast.lua"))()
end
