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
local QuestionOfDayController

local Interface: ScreenGui
local QuestionText: TextLabel
local AnswerButtons: { TextButton } = {}

--
local QuestionOfDay = {}

function QuestionOfDay:Show()
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

function QuestionOfDay:Hide()
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

function QuestionOfDay:DisplayQuestion(question: table)
	QuestionText.Text = question.Question

	for index: number, answer: string in pairs(question.Answers) do
		AnswerButtons[index].Text = answer
	end
end

function QuestionOfDay:ClearQuestion()
	QuestionText.Text = ""
end

function QuestionOfDay:Init(interfaceController)
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	local screen: ScreenGui = ReplicatedStorage.Assets.UI.Screens:WaitForChild("QuestionOfDay", 5)

	if not screen then
		warn("QuestionOfDay ui not found!")
		return
	end

	Interface = screen:Clone()
	Interface.Parent = playerGui

	QuestionOfDayController = require(ReplicatedStorage.Client.Controllers.QuestionOfDayController)

	QuestionText = Interface.Main.QuestionText

	AnswerButtons[1] = Interface.Main.AnswersFrame.Answer1
	AnswerButtons[2] = Interface.Main.AnswersFrame.Answer2
	AnswerButtons[3] = Interface.Main.AnswersFrame.Answer3

	for index: number, button: TextButton in ipairs(AnswerButtons) do
		interfaceController:AddHoverEffect(button, true)
		interfaceController:AddButtonClick(button, function()
			QuestionOfDayController:SubmitAnswer(index)
		end, "Click")
	end
end

return QuestionOfDay
