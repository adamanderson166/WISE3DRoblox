-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local Interface: ScreenGui
local SubmitButton: ImageButton
local JournalTextBox: TextBox
local CloseButton: ImageButton

--
local Journal = {}

function Journal:Show()
	Interface.Main.Position = UDim2.fromScale(0.5, -1)

	TweenService:Create(
		Interface.Main,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = UDim2.fromScale(0.5, 0.5) }
	):Play()

	Interface.Enabled = true
end

function Journal:Hide()
	TweenService:Create(
		Interface.Main,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = UDim2.fromScale(0.5, -1) }
	):Play()

	Interface.Enabled = false
end

function Journal:Init(interfaceController)
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	local screen: ScreenGui = ReplicatedStorage.Assets.UI.Screens:WaitForChild("Journal", 5)

	if not screen then
		warn("Journal ui not found!")
		return
	end

	Interface = screen:Clone()
	Interface.Parent = playerGui

	SubmitButton = Interface:FindFirstChild("SubmitButton", true)
	JournalTextBox = Interface:FindFirstChild("JournalTextBox", true)
	CloseButton = Interface:FindFirstChild("CloseButton", true)

	JournalTextBox.ClearTextOnFocus = false

	interfaceController:AddButtonClick(CloseButton, function()
		self:Hide()
		interfaceController:ShowInterface("Hud")
	end)

	interfaceController:AddHoverEffect(SubmitButton, true)
	interfaceController:AddButtonClick(SubmitButton, function()
		--JournalController:SubmitJournal()
	end)
end

return Journal
