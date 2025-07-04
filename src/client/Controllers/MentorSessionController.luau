-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)

-- Modules
local MentorDialogueData = require(ReplicatedStorage.Client.Modules.MentorDialogueData)

-- Variables
local PlayerDataController
local UserInterfaceController
local HudController
local MentorSessionService
local NotificationController

local Interface
local MentorSession

--
local MentorSessionController = {}

function MentorSessionController:StartMentorSession(mentorName: string, sessionEndCallback: () -> ())
	local available: boolean = MentorSessionService:MentorSessionAvailable()

	if not available then
		sessionEndCallback()
		NotificationController:Notify("You have already taken a mentor session for today.")
		return
	end

	MentorSession = PlayerDataController:GetKey("MentorSessions"):expect()[mentorName]

	HudController:Hide()

	if not MentorSession then
		MentorSession = { Progress = 1 }
	end

	MentorSession.MentorName = mentorName

	local mentorDialogueData: table =
		MentorDialogueData:GetMentorDialogueAtIndex(MentorSession.MentorName, MentorSession.Progress)

	MentorSession.Dialogue = mentorDialogueData.Dialogue
	MentorSession.Topic = mentorDialogueData.Topic
	MentorSession.EndSessionCallback = sessionEndCallback

	Interface:Show()
	Interface:SetMentorDialogue({
		dialogue = MentorSession.Dialogue,
		topic = MentorSession.Topic,
		progress = MentorSession.Progress / #MentorDialogueData:GetMentorDialoguesData(MentorSession.MentorName),
	})
end

function MentorSessionController:EndMentorSession()
	-- Update the mentor session progress
	MentorSession.Progress = MentorSession.Progress
				< #MentorDialogueData:GetMentorDialoguesData(MentorSession.MentorName)
			and MentorSession.Progress + 1
		or 1

	MentorSessionService:SetMentorSession(MentorSession.MentorName, MentorSession.Progress)

	HudController:Show()

	if MentorSession.EndSessionCallback then
		MentorSession.EndSessionCallback()
	end

	MentorSession = nil
end

function MentorSessionController:OnStart()
	PlayerDataController = require(ReplicatedStorage.Client.Controllers.PlayerDataController)
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)
	HudController = require(ReplicatedStorage.Client.Controllers.HudController)
	NotificationController = require(ReplicatedStorage.Client.Controllers.NotificationController)

	MentorSessionService = Cardinal.GetService("MentorSessionService")

	Interface = UserInterfaceController:GetInterface("MentorDialogue")
end

return MentorSessionController
