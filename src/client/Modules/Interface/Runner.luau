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
		if not CountdownText then
			warn("CountdownText not found!")
			reject()
		end

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

		resolve()
	end)
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

	CountdownFrame = Interface.CountdownFrame
	CountdownText = CountdownFrame.CountdownText
end

return Runner
