-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Modules
local MentorDialogueData = require(ReplicatedStorage.Client.Modules.MentorDialogueData)

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local MentorSessionController

local Interface: ScreenGui

--
local MentorList = {}

function MentorList:Show()
	Interface.Main.UIScale.Scale = 0

	Interface.Enabled = true

	TweenService
		:Create(
			Interface.Main.UIScale,
			TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0),
			{
				Scale = 1,
			}
		)
		:Play()
end

function MentorList:Hide()
	TweenService
		:Create(
			Interface.Main.UIScale,
			TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0),
			{
				Scale = 0,
			}
		)
		:Play()

	Interface.Enabled = false
end

function MentorList:Init(interfaceController)
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	local screen: ScreenGui = ReplicatedStorage.Assets.UI.Screens:WaitForChild("MentorList", 5)

	if not screen then
		warn("MentorList ui not found!")
		return
	end

	Interface = screen:Clone()
	Interface.Parent = playerGui

	local closeButton: TextButton = Interface.Main:FindFirstChild("CloseButton", true)
	interfaceController:AddButtonClick(closeButton, function()
		self:Hide()
		interfaceController:ShowInterface("Hud")
	end, "ClickClose")

	MentorSessionController = require(ReplicatedStorage.Client.Controllers.MentorSessionController)

	-- Set up the mentor list entries
	local mentorList: ScrollingFrame = Interface:FindFirstChild("MentorListFrame", true).ScrollingFrame

	for mentorName: string, _ in pairs(MentorDialogueData:GetData()) do
		local mentorEntry: TextButton = ReplicatedStorage.Assets.UI.Templates.MentorNameEntry:Clone()
		mentorEntry.Name = mentorName
		mentorEntry.Parent = mentorList
		mentorEntry.Text = mentorName

		interfaceController:AddHoverEffect(mentorEntry, true)
		interfaceController:AddButtonClick(mentorEntry, function()
			MentorSessionController:TeleportToMentor(mentorName)
			self:Hide()
		end, "Click")
	end
end

return MentorList
