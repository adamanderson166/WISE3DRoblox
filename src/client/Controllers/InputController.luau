-- Services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

-- Constants
local GAMEPAD_SENSITIVITY = 0.008
local GAMEPAD_DEAD_ZONE = 0.1
local MOUSE_SENSITIVITY = 0.001
local TOUCH_SENSITIVITY = 0.002

--
local InputController = {}

function InputController:GetInputDelta()
	return self._inputDelta
end

function InputController:ListenToInputDeltaChange()
	local lastTouchPosition: Vector2? = nil

	self._trove:Add(UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		self._inputDelta = Vector2.zero

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousDelta: Vector2 = UserInputService:GetMouseDelta()
			self._inputDelta = Vector2.new(mousDelta.X * MOUSE_SENSITIVITY, mousDelta.Y * MOUSE_SENSITIVITY)
		elseif
			input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.Change
		then
			local touchPosition = Vector2.new(input.Position.X, input.Position.Y)

			if lastTouchPosition then
				local diff = touchPosition - lastTouchPosition
				self._inputDelta = Vector2.new(diff.X * TOUCH_SENSITIVITY, diff.Y * TOUCH_SENSITIVITY)
			end

			lastTouchPosition = touchPosition
		elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
			local stickPosition = input.Position

			local xInput = math.abs(stickPosition.X) > GAMEPAD_DEAD_ZONE and stickPosition.X or 0
			local yInput = math.abs(stickPosition.Y) > GAMEPAD_DEAD_ZONE and stickPosition.Y or 0

			if xInput ~= 0 or yInput ~= 0 then
				self._inputDelta = Vector2.new(xInput * GAMEPAD_SENSITIVITY, yInput * GAMEPAD_SENSITIVITY)
			end
		end
	end))

	self._trove:Add(UserInputService.TouchStarted:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		lastTouchPosition = Vector2.new(input.Position.X, input.Position.Y)
	end))
end

function InputController:ListenToInputBegan(
	inputTypes: { Enum.UserInputType },
	keys: { Enum.KeyCode },
	callback: () -> ()
)
	self._trove:Add(UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		for _, inputType: Enum.UserInputType in ipairs(inputTypes) do
			if input.UserInputType == inputType then
				callback()
				break
			end
		end

		for _, key: Enum.KeyCode in ipairs(keys) do
			if input.KeyCode == key then
				callback()
				break
			end
		end
	end))
end

function InputController:ClearInputListeners()
	self._trove:Clean()
end

function InputController:GetLastInputType()
	return UserInputService:GetLastInputType()
end

function InputController:OnLastInputTypeChanged(callback: (Enum.UserInputType) -> ())
	local connection: RBXScriptConnection = UserInputService.LastInputTypeChanged:Connect(callback)
	return connection
end

function InputController:OnInit()
	self._inputDelta = Vector2.zero
	self._trove = Trove.new()
end

return InputController
