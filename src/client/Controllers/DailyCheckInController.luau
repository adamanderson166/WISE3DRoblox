-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)

-- Variables
local PlayerDataController
local DailyCheckInService
local NotificationController
local CharacterController

--
local DailyCheckInController = {}

function DailyCheckInController:CheckIn()
	local status: string = DailyCheckInService:CheckIn()

	if status == "Success" or status == "FirstCheckIn" then
		NotificationController:Notify("Daily check-in successful!")
	elseif status == "AlreadyCheckedIn" then
		NotificationController:Notify("You have already checked in today.")
	end

	return status
end

function DailyCheckInController:MoveToDailyCheckInPortal()
	local dailyLoginSpawn: BasePart = workspace:FindFirstChild("DailyLoginSpawn")
	CharacterController:MoveToLocation(dailyLoginSpawn.Position)
end

function DailyCheckInController:OnStart()
	PlayerDataController = require(ReplicatedStorage.Client.Controllers.PlayerDataController)
	NotificationController = require(ReplicatedStorage.Client.Controllers.NotificationController)
	CharacterController = require(ReplicatedStorage.Client.Controllers.CharacterController)
	DailyCheckInService = Cardinal.GetService("DailyCheckInService")

	PlayerDataController:ObserveChange("DailyCheckInStreak", function(streak: number)
		--print(`Daily Streak : {streak}`)
	end)
end

return DailyCheckInController
