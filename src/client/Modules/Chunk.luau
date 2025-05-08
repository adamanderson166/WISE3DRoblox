-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

--
local Chunk = {}

function Chunk:new(startingPosition: Vector3, index: number, offset: number)
	-- Create a new instance of the Chunk model
	local clone: Model = ReplicatedStorage.Assets.EndlessRunner.Chunk:Clone()
	clone.Parent = workspace.EndlessRunner
	clone:PivotTo(CFrame.new(startingPosition + Vector3.new(0, 0, offset * index)))

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
