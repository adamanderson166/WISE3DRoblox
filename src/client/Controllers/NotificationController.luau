-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)

-- Variables
local NotificationService
local UserInterfaceController

local Interface

--
local NotificationController = {}

function NotificationController:Notify(notificationText: string, duration: number?)
	if Interface then
		Interface:Notify(notificationText, duration)
	end
end

function NotificationController:OnStart()
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)
	NotificationService = Cardinal.GetService("NotificationService")

	NotificationService.Notify:Connect(function(notificationText: string)
		if Interface then
			Interface:Notify(notificationText)
		end
	end)

	Interface = UserInterfaceController:GetInterface("Notification")
end

return NotificationController
