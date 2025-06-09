-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Modules
local LevelUtility = require(ReplicatedStorage.Shared.Modules.LevelUtility)

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local Interface: ScreenGui
local CloseButton: TextButton
local CurrentLevel: TextLabel
local NextLevelXp: TextLabel
local DailyCheckInText: TextLabel
local TotalJournals: TextLabel
local TotalQuestions: TextLabel
local TotalAssessments: TextLabel
local TotalMentorSessions: TextLabel

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
	NextLevelXp.Text = `{xp} / 1000`
end

function Profile:SetDailyCheckIns(count: number)
	DailyCheckInText.Text = `Daily Login Streak: {count}`
end

function Profile:SetJournals(count: number)
	TotalJournals.Text = `Total submitted: {count}`
end

function Profile:SetQuestionsAnswered(count: number)
	TotalQuestions.Text = `Total answered: {count}`
end

function Profile:SetSelfAssessments(count: number)
	TotalAssessments.Text = `Total challenges: {count}`
end

function Profile:SetMentorSessions(count: number)
	TotalMentorSessions.Text = `Total sessions: {count}`
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

	task.spawn(function()
		local dailyCheckInButton: TextButton = Interface.Main:FindFirstChild("DailyCheckInButton", true)
		local goToJournalButton: TextButton = Interface.Main:FindFirstChild("GoToJournalButton", true)
		local goToQuestionButton: TextButton = Interface.Main:FindFirstChild("GoToQuestionButton", true)
		local goToSelfAssessmentButton: TextButton = Interface.Main:FindFirstChild("GoToSelfAssessmentButton", true)
		local goToMentorSessionButton: TextButton = Interface.Main:FindFirstChild("GoToMentorSessionButton", true)

		dailyCheckInButton.Activated:Connect(function() end)

		goToJournalButton.Activated:Connect(function() end)

		goToQuestionButton.Activated:Connect(function() end)

		goToSelfAssessmentButton.Activated:Connect(function() end)

		goToMentorSessionButton.Activated:Connect(function() end)
	end)
end

return Profile
