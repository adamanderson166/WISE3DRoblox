-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Packages
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local Interfaces = {}

--
local UserInterfaceController = {}

local function InitializeInterfaces()
	local screens: { ScreenGui } = ReplicatedStorage.Assets.UI:WaitForChild("Screens", 5):GetChildren()
	local playerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

	for _, screen: ScreenGui in ipairs(screens) do
		local interface: ScreenGui = screen:Clone()
		interface.Parent = playerGui
	end
end

function UserInterfaceController:AddHoverEffect(button: TextButton | ImageButton)
	if not button:IsA("TextButton") and not button:IsA("ImageButton") then
		warn("Expected textButton or imageButton for hover effect.")
		return
	end

	local size: UDim2 = button.Size

	button.MouseEnter:Connect(function()
		TweenService
			:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), {
				Size = UDim2.fromScale(size.X.Scale * 1.05, size.Y.Scale * 1.05),
			})
			:Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService
			:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), {
				Size = UDim2.fromScale(size.X.Scale, size.Y.Scale),
			})
			:Play()
	end)
end

function UserInterfaceController:AddButtonClick(button: TextButton | ImageButton, callback: () -> (), sound: string)
	if not button:IsA("TextButton") and not button:IsA("ImageButton") then
		warn("Expected textButton or imageButton for hover effect.")
		return
	end

	if not callback then
		warn("Callback function is required.")
		return
	end

	button.Activated:Connect(function()
		callback()

		if sound then
			-- Play sound effect
		end
	end)
end

function UserInterfaceController:OnInit()
	InitializeInterfaces()
end

return UserInterfaceController
