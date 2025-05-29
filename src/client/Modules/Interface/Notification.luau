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
local Interface: ScreenGui

-- Constants
local NOTIFICATION_DURATION = 4

--
local Notification = {}

function Notification:Notify(notificationText: string, duration: number?)
	local notificationFrame: Frame = Interface:FindFirstChild("NotificationFrame", true):Clone()
	notificationFrame.Parent = Interface
	notificationFrame.NotificationText.Text = notificationText

	notificationFrame.Visible = true
	notificationFrame.Position = UDim2.fromScale(0.5, 2)

	TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.98),
	}):Play()

	task.delay(duration and duration or NOTIFICATION_DURATION, function()
		local tween: TweenBase =
			TweenService:Create(notificationFrame, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
				Position = UDim2.fromScale(0.5, 2),
			})

		tween:Play()
		tween.Completed:Wait()

		notificationFrame:Destroy()
	end)
end

function Notification:Init()
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	local screen: ScreenGui = ReplicatedStorage.Assets.UI.Screens:WaitForChild("Notification", 5)

	if not screen then
		warn("Notification ui not found!")
		return
	end

	Interface = screen:Clone()
	Interface.Parent = playerGui
end

return Notification
