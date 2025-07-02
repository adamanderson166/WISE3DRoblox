-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)
local Component = require(Packages.Component)

-- Modules
local TroveAdder = require(ReplicatedStorage.Shared.Modules.ComponentExtensions.TroveAdder)

-- Variables
local MentorSessionController

--
local Mentor = Component.new({
	Tag = "Mentor",
	Extensions = { TroveAdder },
	Ancestors = { workspace },
})

function Mentor:Start()
	MentorSessionController = require(ReplicatedStorage.Client.Controllers.MentorSessionController)

	local proximityPrompt: ProximityPrompt = Instance.new("ProximityPrompt")
	proximityPrompt.ActionText = "Talk"
	proximityPrompt.MaxActivationDistance = 10
	proximityPrompt.RequiresLineOfSight = false
	proximityPrompt.HoldDuration = 0
	proximityPrompt.Enabled = true

	proximityPrompt.Parent = self.Instance

	proximityPrompt.Triggered:Connect(function()
		local mentorName = self.Instance:GetAttribute("MentorName")

		if not mentorName then
			warn("Mentor name not set on the instance.")
			return
		end

		proximityPrompt.Enabled = false

		MentorSessionController:StartMentorSession(mentorName, function()
			proximityPrompt.Enabled = true
		end)
	end)

	self._trove:Add(proximityPrompt)
end

return Mentor
