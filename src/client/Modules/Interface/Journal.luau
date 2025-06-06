-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local JournalController

local JournalEntries: { Frame } = {}

local ReadModeFrame: Frame
local WriteModeFrame: Frame
local LastJournalEntry: Frame
local Interface: ScreenGui
local SubmitButton: ImageButton
local WriteTextBox: TextBox
local ReadTextBox: TextBox
local CloseButton: TextButton
local JournalModeFrame: Frame
local CurrentMode: string = "None"

-- Constants
local MIN_TEXT_SIZE = 14
local MAX_TEXT_SIZE = 60
local TEXT_SIZE_RATIO = 1 / 20
local MAX_JOURNAL_WORDS = 350

--
local Journal = {}

-- Update height of the text box based on the text content
local function updateTextBoxHeight(textBox: TextBox, scrollingFrame: ScrollingFrame)
	local textHeight: number = textBox.TextBounds.Y
	local frameHeight: number = scrollingFrame.AbsoluteSize.Y

	local heightScale: number = textHeight / frameHeight
	scrollingFrame.CanvasSize = UDim2.fromScale(0, heightScale)
end

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
	WriteTextBox.Text = ""
end

function Journal:ChangeMode(mode: string)
	if mode == CurrentMode then
		return
	end

	local prevModeButton: ImageButton = JournalModeFrame:FindFirstChild(CurrentMode)

	if prevModeButton then
		prevModeButton:FindFirstChild("UIStroke").Enabled = false
		prevModeButton.Size = UDim2.fromScale(0.3, 0.3)
		Interface.Main:FindFirstChild(`{CurrentMode}Mode`).Visible = false
	end

	CurrentMode = mode

	local currentModeButton: ImageButton = JournalModeFrame:FindFirstChild(CurrentMode)

	if not currentModeButton then
		warn("Current mode button not found: " .. CurrentMode)
		return
	end

	currentModeButton:FindFirstChild("UIStroke").Enabled = true
	currentModeButton.Size = UDim2.fromScale(0.35, 0.35)

	Interface.Main:FindFirstChild(`{CurrentMode}Mode`).Visible = true
end

function Journal:SetJournalEntries(journals: table)
	ReadModeFrame.JournalEntriesFrame.Visible = #journals > 0
	ReadModeFrame.SelectedEntryText.Visible = #journals > 0
	ReadModeFrame.DescriptionText.Visible = #journals > 0
	ReadModeFrame.JournalEmptyText.Visible = #journals == 0

	if #journals == 0 then
		return
	end

	-- Populate journal entries
	local lastEntry: number = #JournalEntries

	for i = lastEntry + 1, #journals do
		local entry: { Date: string, Text: string } = journals[i]

		local entryFrame: Frame = ReplicatedStorage.Assets.UI.Templates.JournalEntry:Clone()
		entryFrame.Parent = ReadModeFrame.JournalEntriesFrame.ScrollingFrame
		entryFrame.Visible = true

		entryFrame.Name = `Entry{i}`
		entryFrame:FindFirstChild("Date").Text = entry.Date
		entryFrame:FindFirstChild("Title").Text = `Journal Entry {i}`
		entryFrame:FindFirstChild("Icon"):FindFirstChild("Number").Text = i

		entryFrame:FindFirstChild("Button").Activated:Connect(function()
			if LastJournalEntry then
				LastJournalEntry:FindFirstChild("UIStroke").Thickness = 2
			end

			entryFrame:FindFirstChild("UIStroke").Thickness = 5
			ReadTextBox.Text = entry.Text
			--updateTextBoxHeight(ReadTextBox, ReadModeFrame.SelectedEntryText)

			LastJournalEntry = entryFrame
		end)
	end
end

function Journal:Init(interfaceController)
	JournalController = require(ReplicatedStorage.Client.Controllers.JournalController)

	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	local screen: ScreenGui = ReplicatedStorage.Assets.UI.Screens:WaitForChild("Journal", 5)

	if not screen then
		warn("Journal ui not found!")
		return
	end

	Interface = screen:Clone()
	Interface.Parent = playerGui

	ReadModeFrame = Interface:FindFirstChild("ReadMode", true)
	WriteModeFrame = Interface:FindFirstChild("WriteMode", true)

	SubmitButton = Interface:FindFirstChild("SubmitButton", true)
	WriteTextBox = Interface:FindFirstChild("WriteTextBox", true)
	ReadTextBox = ReadModeFrame:FindFirstChild("ReadTextBox", true)
	CloseButton = Interface:FindFirstChild("CloseButton", true)

	WriteTextBox.ClearTextOnFocus = false

	local screenHeight: number = Interface.AbsoluteSize.Y
	local targetSize = math.clamp(screenHeight * TEXT_SIZE_RATIO, MIN_TEXT_SIZE, MAX_TEXT_SIZE)

	-- Set the text size of the journal text box for both write and read modes
	WriteTextBox.TextSize = targetSize
	ReadTextBox.TextSize = targetSize

	WriteTextBox:GetPropertyChangedSignal("Text"):Connect(function()
		if string.len(WriteTextBox.Text) > MAX_JOURNAL_WORDS then
			WriteTextBox.Text = WriteTextBox.Text:sub(1, MAX_JOURNAL_WORDS)
		end

		--updateTextBoxHeight(WriteTextBox, WriteModeFrame:FindFirstChild("JournalScrollingFrame", true))
	end)

	interfaceController:AddButtonClick(CloseButton, function()
		self:Hide()
		interfaceController:ShowInterface("Hud")
	end)

	interfaceController:AddHoverEffect(SubmitButton, true)
	interfaceController:AddButtonClick(SubmitButton, function()
		JournalController:SubmitJournal(WriteTextBox.Text)
	end)

	JournalModeFrame = Interface:FindFirstChild("JournalModeFrame", true)

	-- Add button clicks for mode changes
	interfaceController:AddButtonClick(JournalModeFrame:FindFirstChild("Write"), function()
		self:ChangeMode("Write")
	end)

	interfaceController:AddButtonClick(JournalModeFrame:FindFirstChild("Read"), function()
		self:ChangeMode("Read")
	end)

	self:ChangeMode("Write")
end

return Journal
