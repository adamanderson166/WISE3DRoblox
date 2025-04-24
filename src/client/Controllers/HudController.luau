-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Packages
local Packages = ReplicatedStorage.Packages
local TableUtil = require(Packages.TableUtil)

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local LeftPanelToggle: boolean = false

local Interface: ScreenGui
local LeftPanel: Frame
local leftPanelToggleButton: ImageButton

local UserInterfaceController

--
local HudController = {}

local function SetupUi()
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	Interface = playerGui:WaitForChild("Hud", 5)

	if not Interface then
		warn("Hud ui not found!")
	end

	LeftPanel = Interface:WaitForChild("LeftPanel", 5)

	local hudButtonsList: Frame = Interface:FindFirstChild("HudButtonsList", true)

	local buttons: { ImageButton } = TableUtil.Filter(hudButtonsList:GetChildren(), function(child: Instance)
		return child:IsA("ImageButton")
	end)

	for _, button: ImageButton in ipairs(buttons) do
		UserInterfaceController:AddHoverEffect(button)
		UserInterfaceController:AddButtonClick(button, function()
			HudController:Hide()
		end)
	end

	leftPanelToggleButton = LeftPanel:FindFirstChild("ToggleButton", true)

	UserInterfaceController:AddHoverEffect(leftPanelToggleButton)
	UserInterfaceController:AddButtonClick(leftPanelToggleButton, function()
		HudController:ToggleLeftPanel()
	end)
end

function HudController:Show() end

function HudController:Hide() end

function HudController:ToggleLeftPanel()
	LeftPanelToggle = not LeftPanelToggle

	if LeftPanelToggle then
		leftPanelToggleButton.Rotation = 180
		LeftPanel.Position = UDim2.fromScale(-0.062, 0.5)

		TweenService
			:Create(LeftPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
				Position = UDim2.fromScale(0.01, 0.5),
			})
			:Play()
	else
		leftPanelToggleButton.Rotation = 0

		TweenService
			:Create(LeftPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
				Position = UDim2.fromScale(-0.062, 0.5),
			})
			:Play()
	end
end

function HudController:OnStart()
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)

	SetupUi()

	self:ToggleLeftPanel()
end

return HudController
