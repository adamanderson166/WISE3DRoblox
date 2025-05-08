-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

-- Constants
local DEBUG_POSITION = true

--
local Chunk = {}

function Chunk:new(startingPosition: Vector3, index: number, offset: number)
	-- Create a new instance of the Chunk model
	local clone: Model = ReplicatedStorage.Assets.EndlessRunner.Chunk:Clone()
	clone.Parent = workspace.EndlessRunner
	clone:PivotTo(CFrame.new(startingPosition + Vector3.new(0, 0, offset * index)))

	if DEBUG_POSITION then
		local billboardGui: BillboardGui = Instance.new("BillboardGui")
		billboardGui.Parent = clone
		billboardGui.Adornee = clone.PrimaryPart
		billboardGui.Size = UDim2.new(0, 50, 0, 50)
		billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 15, 0)

		local textLabel: TextLabel = Instance.new("TextLabel")
		textLabel.Parent = billboardGui
		textLabel.Size = UDim2.fromScale(1, 1)
		textLabel.TextScaled = true
		textLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = index
	end

	self._chunkModel = clone
	self._trove = Trove.new()

	local chunk: table = {}
	setmetatable(chunk, self)

	self.__index = self

	return chunk
end

function Chunk:Populate()
	-- Populate the chunk with obstacles and environment objects
end

function Chunk:Clear()
	self._trove:Clean()
end

return Chunk
