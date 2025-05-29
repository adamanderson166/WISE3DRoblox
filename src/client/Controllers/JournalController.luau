-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)

-- Variables
local Interface: ScreenGui

local UserInterfaceController
local NotificationController
local JournalService

--
local JournalController = {}

function JournalController:SubmitJournal(journalText: string)
	if string.len(journalText) == 0 then
		NotificationController:Notify("Don't forget to write something that reflects your thoughts!")
		return
	end

	local JournalAvailable: boolean = JournalService:JournalAvailable()

	if JournalAvailable then
		JournalService:SubmitJournal(journalText)
		NotificationController:Notify("Journal submitted successfully!")

		Interface:Hide()
		UserInterfaceController:ShowInterface("Hud")
	else
		NotificationController:Notify("Journal already sbmitted. Come back later!")
	end
end

function JournalController:OnStart()
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)
	NotificationController = require(ReplicatedStorage.Client.Controllers.NotificationController)
	JournalService = Cardinal.GetService("JournalService")

	Interface = UserInterfaceController:GetInterface("Journal")
end

return JournalController
