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

function DailyCheckInService:GetCheckInStatus(player: Player)
	local replica = PlayerDataService:Get(player, 5):expect()

	if not replica then
		return
	end

	local status: string = nil
	local data: table = replica.Data:Get()

	local LastCheckInTimeStamp: number = data.LastCheckInTimeStamp

	-- First time checking in, set the streak to 1
	if LastCheckInTimeStamp == 0 then
		status = "FirstCheckIn"
	else
		local currentTime: number = os.time()
		local timeDifferenceInDays: number = math.floor((currentTime - LastCheckInTimeStamp) / SECONDS_IN_A_DAY)

		-- Player came back the next day, increment the streak by 1
		if timeDifferenceInDays == 1 then
			status = "Success"
		elseif timeDifferenceInDays > 1 then
			-- Player came back after more than a day, reset the streak to 1
			status = "Reset"
		else
			-- Player tried to check in on the same day, do nothing
			status = "AlreadyCheckedIn"
		end
	end

	return status
end

function DailyCheckInService.Client:CheckIn(player: Player)
	local checkInStatus: string = self.Server:GetCheckInStatus(player)

	if checkInStatus == "FirstCheckIn" then
		PlayerDataService:UpdatePlayerStreak(player, 1, os.time())
	elseif checkInStatus == "Success" then
		local replica = PlayerDataService:Get(player, 5):expect()

		if not replica then
			return
		end

		local data: table = replica.Data:Get()

		PlayerDataService:UpdatePlayerStreak(player, data.DailyCheckInStreak + 1, os.time())
	elseif checkInStatus == "Reset" then
		PlayerDataService:UpdatePlayerStreak(player, 1, os.time())
	end

	-- local replica = PlayerDataService:Get(player, 5):expect()

	-- if not replica then
	-- 	return
	-- end

	-- local status: string = nil
	-- local data: table = replica.Data:Get()

	-- local LastCheckInTimeStamp: number = data.LastCheckInTimeStamp

	-- -- First time checking in, set the streak to 1
	-- if LastCheckInTimeStamp == 0 then
	-- 	PlayerDataService:UpdatePlayerStreak(player, 1, os.time())
	-- 	status = "Success"
	-- else
	-- 	local currentTime: number = os.time()
	-- 	local timeDifferenceInDays: number = math.floor((currentTime - LastCheckInTimeStamp) / SECONDS_IN_A_DAY)

	-- 	-- Player came back the next day, increment the streak by 1
	-- 	if timeDifferenceInDays == 1 then
	-- 		PlayerDataService:UpdatePlayerStreak(player, data.DailyCheckInStreak + 1, currentTime)
	-- 		status = "Success"
	-- 	elseif timeDifferenceInDays > 1 then
	-- 		-- Player came back after more than a day, reset the streak to 1
	-- 		PlayerDataService:UpdatePlayerStreak(player, 1, currentTime)
	-- 		status = "Reset"
	-- 	else
	-- 		-- Player tried to check in on the same day, do nothing
	-- 		status = "AlreadyCheckedIn"
	-- 	end
	-- end

	return checkInStatus
end

function DailyCheckInService.Client:GetCheckInStatus(player: Player)
	return self.Server:GetCheckInStatus(player)
end

return DailyCheckInService
