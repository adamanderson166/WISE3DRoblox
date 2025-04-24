-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)
local TableUtil = require(Packages.TableUtil)

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local Interface: ScreenGui
local SubmitButton: ImageButton
local JournalTextBox: TextBox
local TextScrollingFrame: ScrollingFrame

local UserInterfaceController
local JournalService

--
local JournalController = {}

local function SetupUi()
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	Interface = playerGui:WaitForChild("Journal", 5)

	if not Interface then
		warn("Journal ui not found!")
	end

	SubmitButton = Interface:FindFirstChild("SubmitButton", true)
	JournalTextBox = Interface:FindFirstChild("JournalTextBox", true)
	TextScrollingFrame = Interface:FindFirstChild("TextScrollingFrame", true)

	local function updateTextSize()
		local textHeight: number = JournalTextBox.TextBounds.Y
		local scrollingFrameSize: number = TextScrollingFrame.AbsoluteSize.Y

		local scale: number = textHeight / scrollingFrameSize

		JournalTextBox.Size = UDim2.fromScale(0.98, scale)
		TextScrollingFrame.CanvasSize = UDim2.fromScale(0, scale)
	end

	JournalTextBox.ClearTextOnFocus = false

	JournalTextBox.FocusLost:Connect(function()
		updateTextSize()
	end)

	UserInterfaceController:AddHoverEffect(SubmitButton)
	UserInterfaceController:AddButtonClick(SubmitButton, function()
		JournalController:SubmitJournal()
	end)
end

function JournalController:SubmitJournal() end

function JournalController:OnStart()
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)
	JournalService = Cardinal.GetService("JournalService")

	local available: boolean = JournalService:JournalAvailable()
	print(`Journal Available: {available}`)

	SetupUi()
end

return JournalController
