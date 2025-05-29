-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)
local Component = require(Packages.Component)

-- Modules
local TroveAdder = require(ReplicatedStorage.Shared.Modules.ComponentExtensions.TroveAdder)

-- Variables
local DailyCheckInController
local DailyCheckInService

--
local DailyStreakTerminal = Component.new({
	Tag = "DailyStreakTerminal",
	Extensions = { TroveAdder },
	Ancestors = { workspace },
})

function DailyStreakTerminal:Start()
	DailyCheckInController = require(ReplicatedStorage.Client.Controllers.DailyCheckInController)
	DailyCheckInService = Cardinal.GetService("DailyCheckInService")

	local proximityPrompt: ProximityPrompt = Instance.new("ProximityPrompt")
	proximityPrompt.ActionText = "Daily Check In"
	proximityPrompt.MaxActivationDistance = 10
	proximityPrompt.RequiresLineOfSight = false
	proximityPrompt.HoldDuration = 0
	proximityPrompt.Enabled = DailyCheckInService:GetCheckInStatus() ~= "AlreadyCheckedIn"

	proximityPrompt.Parent = self.Instance

	proximityPrompt.Triggered:Connect(function()
		proximityPrompt.Enabled = false
		DailyCheckInController:CheckIn()
	end)
end

return DailyStreakTerminal
