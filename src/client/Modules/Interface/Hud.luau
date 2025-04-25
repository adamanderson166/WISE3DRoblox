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
local LeftPanelToggle: boolean = false

local Interface: ScreenGui
local LeftPanel: Frame
local leftPanelToggleButton: ImageButton

--
local Hud = {}

function Hud:Show()
	LeftPanelToggle = false
	Interface.Enabled = true
	self:ToggleLeftPanel()
end

function Hud:Hide()
	LeftPanelToggle = true
	Interface.Enabled = false
	self:ToggleLeftPanel()
end

function Hud:ToggleLeftPanel()
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

function Hud:Init(interfaceController)
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	local screen: ScreenGui = ReplicatedStorage.Assets.UI.Screens:WaitForChild("Hud", 5)

	if not screen then
		warn("Hud ui not found!")
		return
	end

	Interface = screen:Clone()
	Interface.Parent = playerGui

	LeftPanel = Interface:WaitForChild("LeftPanel", 5)

	local hudButtonsList: Frame = Interface:FindFirstChild("HudButtonsList", true)

	local buttons: { ImageButton } = TableUtil.Filter(hudButtonsList:GetChildren(), function(child: Instance)
		return child:IsA("ImageButton")
	end)

	for _, button: ImageButton in ipairs(buttons) do
		interfaceController:AddHoverEffect(button, true)
		interfaceController:AddButtonClick(button, function()
			self:Hide()
			interfaceController:ShowInterface(button.Name)
		end)
	end

	leftPanelToggleButton = LeftPanel:FindFirstChild("ToggleButton", true)

	interfaceController:AddHoverEffect(leftPanelToggleButton)
	interfaceController:AddButtonClick(leftPanelToggleButton, function()
		self:ToggleLeftPanel()
	end)
end

return Hud
