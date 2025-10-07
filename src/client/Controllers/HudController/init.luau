-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages

-- Variables
local UserInterfaceController
local Interface

--
local HudController = {}

function HudController:Show()
	Interface:Show()
end

function HudController:Hide()
	Interface:Hide()
end

function HudController:OnStart()
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)

	Interface = UserInterfaceController:GetInterface("Hud")

	Interface:Show()
end

return HudController
