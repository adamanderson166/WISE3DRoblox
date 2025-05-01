-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local Interface: ScreenGui
local SubmitButton: ImageButton
local JournalScrollingFrame: ScrollingFrame
local JournalTextBox: TextBox
local CloseButton: TextButton

-- Constants
local MIN_TEXT_SIZE = 14
local MAX_TEXT_SIZE = 60
local TEXT_SIZE_RATIO = 1 / 20

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
	JournalScrollingFrame = Interface:FindFirstChild("JournalScrollingFrame", true)
	JournalTextBox = Interface:FindFirstChild("JournalTextBox", true)
	CloseButton = Interface:FindFirstChild("CloseButton", true)

	-- Update height of the text box based on the text content
	local function updateTextHeight()
		local textHeight: number = JournalTextBox.TextBounds.Y
		local frameHeight: number = JournalScrollingFrame.AbsoluteSize.Y

		local heightScale: number = textHeight / frameHeight

		JournalTextBox.Size = UDim2.fromScale(0.98, heightScale)
		JournalScrollingFrame.CanvasSize = UDim2.fromScale(0, heightScale)
	end

	JournalTextBox.ClearTextOnFocus = false

	local screenHeight: number = Interface.AbsoluteSize.Y
	local targetSize = math.clamp(screenHeight * TEXT_SIZE_RATIO, MIN_TEXT_SIZE, MAX_TEXT_SIZE)
	JournalTextBox.TextSize = targetSize

	JournalTextBox:GetPropertyChangedSignal("Text"):Connect(function()
		updateTextHeight()
	end)

	interfaceController:AddHoverEffect(CloseButton, true)
	interfaceController:AddButtonClick(CloseButton, function()
		self:Hide()
		JournalTextBox.Text = ""
		interfaceController:ShowInterface("Hud")
	end)

	interfaceController:AddHoverEffect(SubmitButton, true)
	interfaceController:AddButtonClick(SubmitButton, function()
		--JournalController:SubmitJournal()
	end)
end

return Journal
