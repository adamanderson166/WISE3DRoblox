-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Packages
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local Interface: ScreenGui
local CountdownFrame: Frame
local CountdownText: TextLabel
local StatsFrame: Frame

--
local Runner = {}

function Runner:Show()
	Interface.Enabled = true
end

function Runner:Hide()
	Interface.Enabled = false
end

function Runner:StartCountdown(countdown: number)
	return Promise.new(function(resolve, reject)
		CountdownFrame.Visible = true

		CountdownText.TextTransparency = 0
		CountdownText.UIStroke.Transparency = 0
		CountdownText.Text = countdown

		for i: number = countdown, 1, -1 do
			CountdownText.Text = tostring(i)
			task.wait(1)
		end

		CountdownText.Text = "GO!"

		task.wait(1)

		TweenService:Create(
			CountdownText,
			TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0),
			{ TextTransparency = 1 }
		):Play()

		TweenService:Create(
			CountdownText.UIStroke,
			TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0),
			{ Transparency = 1 }
		):Play()

		resolve()
	end)
end

function Runner:ToggleStats(toggle: boolean)
	StatsFrame.Visible = toggle
end

function Runner:SetDistanceTraveled(distance: number)
	StatsFrame.DistanceFrame.Value.Text = distance
end

function Runner:SetCoins(coins: number)
	StatsFrame.CoinsFrame.Value.Text = coins
end

function Runner:SetScore(score: number)
	StatsFrame.ScoreFrame.Value.Text = score
end

function Runner:SetScoreMultiplier(multiplier: number)
	StatsFrame.ScoreFrame.Multiplier.Text = `x{multiplier}`
end

function Runner:Init(interfaceController)
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	local screen: ScreenGui = ReplicatedStorage.Assets.UI.Screens:WaitForChild("Runner", 5)

	if not screen then
		warn("Runner ui not found!")
		return
	end

	Interface = screen:Clone()
	Interface.Parent = playerGui

	StatsFrame = Interface.StatsFrame
	CountdownFrame = Interface.CountdownFrame
	CountdownText = CountdownFrame.CountdownText
end

return Runner
