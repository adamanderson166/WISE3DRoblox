-- Services
local ServerStorage = game:GetService("ServerStorage")

-- Variables
local PlayerDataService

--
local CurrencyService = {
	Client = {},
}

function CurrencyService.Client:SetCoins(player: Player, coins: number)
	PlayerDataService:SetCoins(player, coins)
end

function CurrencyService:OnStart()
	PlayerDataService = require(ServerStorage.Server.Services.PlayerDataService)
end

return CurrencyService
