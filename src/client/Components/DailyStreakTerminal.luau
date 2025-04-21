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

--
local DailyStreakTerminal = Component.new({
	Tag = "DailyStreakTerminal",
	Extensions = { TroveAdder },
	Ancestors = { workspace },
})

function DailyStreakTerminal:Start()
	DailyCheckInController = require(ReplicatedStorage.Client.Controllers.DailyCheckInController)

	local proximityPrompt: ProximityPrompt = Instance.new("ProximityPrompt")
	proximityPrompt.ActionText = "Daily Check In"
	proximityPrompt.MaxActivationDistance = 15
	proximityPrompt.RequiresLineOfSight = false
	proximityPrompt.HoldDuration = 0
	proximityPrompt.Enabled = true

	local tablePart: BasePart = self.Instance:WaitForChild("Table", 5)
	proximityPrompt.Parent = tablePart

	proximityPrompt.Triggered:Connect(function()
		-- Daily check in
		DailyCheckInController:CheckIn()
	end)
end

return DailyStreakTerminal
