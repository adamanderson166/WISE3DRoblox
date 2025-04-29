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
local CloseButton: ImageButton

-- Constants
local MAX_JOURNAL_LENGTH: number = 400
local MAX_CANVAS_SIZE_SCALE = 1.3

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
		JournalScrollingFrame.CanvasSize = UDim2.fromScale(0, math.clamp(heightScale, 0, MAX_CANVAS_SIZE_SCALE))
	end

	JournalTextBox.ClearTextOnFocus = false

	JournalTextBox:GetPropertyChangedSignal("Text"):Connect(function()
		local textLength: number = #JournalTextBox.Text

		if textLength > MAX_JOURNAL_LENGTH then
			JournalTextBox.Text = JournalTextBox.Text:sub(1, MAX_JOURNAL_LENGTH)
		end

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
