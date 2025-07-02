-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local MentorDialogueData = require(ReplicatedStorage.Client.Modules.MentorDialogueData)

-- Variables
local PlayerDataController
local UserInterfaceController

local Interface

--
local MentorSessionController = {}

function MentorSessionController:StartMentorSession(mentorName: string, sessionEndCallback: () -> ()) end

function MentorSessionController:OnStart()
	PlayerDataController = require(ReplicatedStorage.Client.Controllers.PlayerDataController)
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)

	--Interface = UserInterfaceController:GetInterface("Mentor")
end

return MentorSessionController
