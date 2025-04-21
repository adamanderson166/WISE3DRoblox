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
		local currentTime: number = workspace:GetServerTimeNow()

		print(os.date("%c", currentTime))

		-- If player comes back within a day, increment the streak
		-- Otherwise, reset the streak to 1
		local inTime: boolean = currentTime - data.LastCheckInTimestamp < SECONDS_IN_A_DAY

		PlayerDataService:UpdatePlayerStreak(player, inTime and (data.DailyCheckInStreak + 1) or 1, currentTime)
	end)
end

return DailyCheckInService
