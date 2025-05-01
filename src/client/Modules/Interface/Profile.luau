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
local CloseButton: TextButton

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
end

return Profile
