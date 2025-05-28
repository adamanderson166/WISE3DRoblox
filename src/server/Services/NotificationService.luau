-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)

--
local NotificationService = {
	Client = {
		Notify = Cardinal.CreateSignal(),
	},
}

function NotificationService:NotifyPlayers(notificationText: string)
	NotificationService.Notify:FireAll(notificationText)
end

return NotificationService
