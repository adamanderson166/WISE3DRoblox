-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)

-- Variables
local PlayerDataController
local DailyCheckInService

--
local DailyCheckInController = {}

function DailyCheckInController:CheckIn()
	local status: string = DailyCheckInService:CheckIn()

	if status == "Success" then
		print("Daily check-in successful!")
	elseif status == "AlreadyCheckedIn" then
		print("You have already checked in today.")
	end
end

function DailyCheckInController:OnStart()
	PlayerDataController = require(ReplicatedStorage.Client.Controllers.PlayerDataController)
	DailyCheckInService = Cardinal.GetService("DailyCheckInService")

	PlayerDataController:ObserveChange("DailyCheckInStreak", function(streak: number)
		--print(`Daily Streak : {streak}`)
	end)
end

return DailyCheckInController
