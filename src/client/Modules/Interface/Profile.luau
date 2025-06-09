-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Modules
local LevelUtility = require(ReplicatedStorage.Shared.Modules.LevelUtility)

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local DailyCheckInController

local Interface: ScreenGui
local CloseButton: TextButton
local CurrentLevel: TextLabel
local NextLevelXp: TextLabel
local DailyCheckInText: TextLabel
local TotalJournals: TextLabel
local TotalQuestions: TextLabel
local TotalAssessments: TextLabel
local TotalMentorSessions: TextLabel
local TotalRuns: TextLabel
local TotalDeaths: TextLabel
local HighScore: TextLabel
local MaxDistance: TextLabel

--
local Profile = {}

function Profile:Show()
	Interface.Main.Position = UDim2.fromScale(0.5, -1)

	TweenService:Create(
		Interface.Main,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = UDim2.fromScale(0.5, 0.5) }
	):Play()

	Interface.Enabled = true
end

function Profile:Hide()
	TweenService:Create(
		Interface.Main,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = UDim2.fromScale(0.5, -1) }
	):Play()

	Interface.Enabled = false
end

function Profile:SetLevelAndXp(level: number, xp: number)
	CurrentLevel.Text = `Level {level}`

	NextLevelXp.Text = `{xp} / {LevelUtility:GetTotalXpToReachLevel(level + 1)}`
end

function Profile:SetDailyCheckIns(count: number)
	DailyCheckInText.Text = `Daily Login Streak: {count}`
end

function Profile:SetJournals(count: number)
	TotalJournals.Text = `Total Submitted: {count}`
end

function Profile:SetQuestionsAnswered(count: number)
	TotalQuestions.Text = `Total Answered: {count}`
end

function Profile:SetSelfAssessments(count: number)
	TotalAssessments.Text = `Total Challenges: {count}`
end

function Profile:SetMentorSessions(count: number)
	TotalMentorSessions.Text = `Total Sessions: {count}`
end

function Profile:SetMinigameStats(stats: table)
	TotalRuns.Text = `Total Runs: {stats.Runs}`
	TotalDeaths.Text = `Total Deaths: {stats.Deaths}`
	HighScore.Text = `High Score: {stats.HighScore}`
	MaxDistance.Text = `Max Distance: {stats.MaxDistance}`
end

function Profile:Init(interfaceController)
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	local screen: ScreenGui = ReplicatedStorage.Assets.UI.Screens:WaitForChild("Profile", 5)

	if not screen then
		warn("Profile ui not found!")
		return
	end

	Interface = screen:Clone()
	Interface.Parent = playerGui

	CloseButton = Interface:FindFirstChild("CloseButton", true)

	interfaceController:AddHoverEffect(CloseButton, true)
	interfaceController:AddButtonClick(CloseButton, function()
		self:Hide()
		interfaceController:ShowInterface("Hud")
	end)

	CurrentLevel = Interface.Main:FindFirstChild("CurrentLevel", true)
	NextLevelXp = Interface.Main:FindFirstChild("NextLevelXp", true)

	DailyCheckInText = Interface.Main:FindFirstChild("DailyCheckInText", true)
	TotalJournals = Interface.Main:FindFirstChild("TotalJournals", true)
	TotalQuestions = Interface.Main:FindFirstChild("TotalQuestions", true)
	TotalAssessments = Interface.Main:FindFirstChild("TotalAssessments", true)
	TotalMentorSessions = Interface.Main:FindFirstChild("TotalSessions", true)

	TotalRuns = Interface.Main:FindFirstChild("TotalRuns", true)
	TotalDeaths = Interface.Main:FindFirstChild("TotalDeaths", true)
	HighScore = Interface.Main:FindFirstChild("HighScore", true)
	MaxDistance = Interface.Main:FindFirstChild("MaxDistance", true)

	DailyCheckInController = require(ReplicatedStorage.Client.Controllers.DailyCheckInController)

	task.spawn(function()
		local dailyCheckInButton: TextButton = Interface.Main:FindFirstChild("DailyCheckInButton", true)
		local goToJournalButton: TextButton = Interface.Main:FindFirstChild("GoToJournalButton", true)
		local goToQuestionButton: TextButton = Interface.Main:FindFirstChild("GoToQuestionButton", true)
		local goToSelfAssessmentButton: TextButton = Interface.Main:FindFirstChild("GoToSelfAssessmentButton", true)
		local goToMentorSessionButton: TextButton = Interface.Main:FindFirstChild("GoToMentorSessionButton", true)

		dailyCheckInButton.Activated:Connect(function()
			self:Hide()
			DailyCheckInController:MoveToDailyCheckInPortal()
			interfaceController:ShowInterface("Hud")
		end)

		goToJournalButton.Activated:Connect(function()
			self:Hide()
			interfaceController:ShowInterface("Journal")
		end)

		goToQuestionButton.Activated:Connect(function() end)

		goToSelfAssessmentButton.Activated:Connect(function() end)

		goToMentorSessionButton.Activated:Connect(function() end)
	end)
end

return Profile
