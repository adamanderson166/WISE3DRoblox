-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Packages
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

-- References
local UiFolder = ReplicatedStorage.Client.Modules.Interface

-- Variables
local Interfaces: { [string]: ModuleScript } = {}

--
local UserInterfaceController = {}

local function InitializeInterfaces()
	for _, interface: ModuleScript in ipairs(UiFolder:GetChildren()) do
		Interfaces[interface.Name] = require(interface)
		Interfaces[interface.Name]:Init(UserInterfaceController)
	end
end

function UserInterfaceController:GetInterface(interfaceName: string)
	if not Interfaces[interfaceName] then
		warn(`Interface {interfaceName} not found!`)
		return
	end

	return Interfaces[interfaceName]
end

function UserInterfaceController:ShowInterface(interfaceName: string)
	local interface = self:GetInterface(interfaceName)

	if interface then
		interface:Show()
	end
end

function UserInterfaceController:AddHoverEffect(button: TextButton | ImageButton, resetEffectOnClick: boolean)
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

	if resetEffectOnClick then
		button.Activated:Connect(function()
			button.Size = size
		end)
	end
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
