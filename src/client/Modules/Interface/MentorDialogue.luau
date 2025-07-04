-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Packages
local Packages = ReplicatedStorage.Packages
local TableUtil = require(Packages.TableUtil)

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local MentorSessionController

local Interface: ScreenGui
local DialogueText: TextLabel
local TopicText: TextLabel
local ProgressBarFrame: Frame
local DialogueFrame: Frame
local ProceedButton: ImageButton

--
local MentorDialogue = {}

function MentorDialogue:Show()
	ProgressBarFrame.Position = UDim2.fromScale(0.5, -1)
	DialogueFrame.Position = UDim2.fromScale(0.5, 2)
	ProceedButton.Position = UDim2.fromScale(0.805, 2)

	Interface.Enabled = true

	TweenService
		:Create(ProgressBarFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
			Position = UDim2.fromScale(0.5, 0.01),
		})
		:Play()

	TweenService
		:Create(DialogueFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
			Position = UDim2.fromScale(0.5, 0.99),
		})
		:Play()

	TweenService
		:Create(ProceedButton, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
			Position = UDim2.fromScale(0.805, 0.99),
		})
		:Play()
end

function MentorDialogue:Hide()
	Interface.Enabled = false
end

function MentorDialogue:SetMentorDialogue(data: { dialogue: string, topic: string, progress: number })
	DialogueText.Text = data.dialogue
	TopicText.Text = data.topic
	ProgressBarFrame.Fill.Size = UDim2.fromScale(data.progress, 1)
end

function MentorDialogue:Init(interfaceController)
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	local screen: ScreenGui = ReplicatedStorage.Assets.UI.Screens:WaitForChild("MentorDialogue", 5)

	if not screen then
		warn("MentorDialogue ui not found!")
		return
	end

	Interface = screen:Clone()
	Interface.Parent = playerGui

	MentorSessionController = require(ReplicatedStorage.Client.Controllers.MentorSessionController)

	DialogueText = Interface:FindFirstChild("DialogueText", true)
	TopicText = Interface:FindFirstChild("TopicText", true)

	ProceedButton = Interface:FindFirstChild("ProceedButton")
	DialogueFrame = Interface:FindFirstChild("DialogueFrame")
	ProgressBarFrame = Interface:FindFirstChild("ProgressBarFrame")

	interfaceController:AddHoverEffect(ProceedButton, true)
	interfaceController:AddButtonClick(ProceedButton, function()
		self:Hide()
		MentorSessionController:EndMentorSession()
	end, "Click")
end

return MentorDialogue
