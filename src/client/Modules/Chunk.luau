-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

-- Constants
local DEBUG_POSITION = false

--
local Chunk = {}
Chunk.__index = Chunk

function Chunk:New(startingPosition: Vector3, step: number, length: number)
	local instance = {}
	setmetatable(instance, Chunk)

	instance._length = length
	instance._trove = Trove.new()

	-- Create a new instance of the Chunk model
	instance._model = ReplicatedStorage.Assets.EndlessRunner.Chunk:Clone()
	instance._model.Parent = workspace.EndlessRunner
	instance._model:SetAttribute("Position", step)

	-- Move to position
	instance:MoveToStepFromPosition(startingPosition, step)

	if DEBUG_POSITION then
		local billboardGui: BillboardGui = Instance.new("BillboardGui")
		billboardGui.Parent = instance._model
		billboardGui.Adornee = instance._model.PrimaryPart
		billboardGui.Size = UDim2.new(0, 50, 0, 50)
		billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 15, 0)

		local textLabel: TextLabel = Instance.new("TextLabel")
		textLabel.Parent = billboardGui
		textLabel.Size = UDim2.fromScale(1, 1)
		textLabel.TextScaled = true
		textLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = step
	end

	return instance
end

function Chunk:MoveToStepFromPosition(referencePosition: Vector3, step: number)
	self._model:PivotTo(CFrame.new(referencePosition + Vector3.new(0, 0, self._length * (step and step or 0))))
end

function Chunk:GetModel()
	return self._model
end

function Chunk:Populate()
	-- Populate the instance with obstacles and environment objects
end

function Chunk:Clear()
	self._trove:Clean()
end

return Chunk
