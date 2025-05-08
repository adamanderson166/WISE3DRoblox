-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

-- Modules
local Chunk = require(ReplicatedStorage.Client.Modules.Chunk)

-- Constants
local CHUNKS_COUNT = 30
local CHUNK_MOVEMENT_SPEED = 15
local CHUNK_RECYCLE_THRESHOLD = 50

-- Variables
local Chunks = {}

--
local EndlessRunnerController = {}

function EndlessRunnerController:SpawnChunks()
	task.spawn(function()
		local chunkRef: Model = ReplicatedStorage.Assets.EndlessRunner:WaitForChild("Chunk", 5)

		local startingPosition: Vector3 = chunkRef:GetPivot().Position
		local chunkLength: number = chunkRef:GetExtentsSize().Z - 0.1 -- Offset to avoid small spaces between chunks
		local threshold: number = (startingPosition - Vector3.new(0, 0, CHUNK_RECYCLE_THRESHOLD)).Z

		-- Spawn chunks
		for i = 0, CHUNKS_COUNT do
			table.insert(Chunks, Chunk:new(startingPosition, i, chunkLength))
		end

		-- Move chunks down the Z-axis
		self._trove:Add(RunService.Heartbeat:Connect(function(deltaTime: number)
			for _, chunk in ipairs(Chunks) do
				local model: Model = chunk:GetModel()
				model:PivotTo(model:GetPivot() + Vector3.new(0, 0, -CHUNK_MOVEMENT_SPEED * deltaTime))
			end

			if Chunks[1]:GetModel():GetPivot().Position.Z < threshold then
				print("Chunk recycled: " .. Chunks[1]:GetIndex())
				local recycledChunk = table.remove(Chunks, 1)
				recycledChunk:GetModel():Destroy()
			end
		end))
	end)
end

function EndlessRunnerController:OnStart()
	self:SpawnChunks()
end

function EndlessRunnerController:OnInit()
	self._trove = Trove.new()
end

return EndlessRunnerController
