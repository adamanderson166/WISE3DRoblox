-- Services
local ServerStorage = game:GetService("ServerStorage")

-- References
local PlayerDataService = require(ServerStorage.Server.Services.PlayerDataService)

-- Constants
local SECONDS_IN_A_DAY = 86400

--
local DailyCheckInService = {
	Client = {},
}

function DailyCheckInService.Client:CheckIn(player: Player)
	PlayerDataService:Get(player, 5):andThen(function(replica: table)
		if not replica then
			return
		end

		local data: table = replica.Data:Get()

		local LastCheckInTimeStamp: number = data.LastCheckInTimeStamp

		-- First time checking in, set the streak to 1
		if LastCheckInTimeStamp == 0 then
			PlayerDataService:UpdatePlayerStreak(player, 1, os.time())
			return
		end

		local currentTime: number = os.time()
		local timeDifferenceInDays: number = math.floor((currentTime - LastCheckInTimeStamp) / SECONDS_IN_A_DAY)

		-- Player came back the next day, increment the streak by 1
		if timeDifferenceInDays == 1 then
			PlayerDataService:UpdatePlayerStreak(player, data.DailyCheckInStreak + 1, currentTime)
		elseif timeDifferenceInDays > 1 then
			-- Player came back after more than a day, reset the streak to 1
			PlayerDataService:UpdatePlayerStreak(player, 1, currentTime)
		end
	end)
end

return DailyCheckInService
