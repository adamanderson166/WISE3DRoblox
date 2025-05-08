-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local Chunk = require(ReplicatedStorage.Client.Modules.Chunk)

-- Constants
local CHUNKS_COUNT = 50

-- Variables
local Chunks: { Model } = {}

--
local EndlessRunnerController = {}

local function SpawnChunks()
	task.spawn(function()
		local chunk: Model = ReplicatedStorage.Assets.EndlessRunner:WaitForChild("Chunk", 5)

		local startingPosition: Vector3 = chunk:GetPivot().Position
		local zOffset: number = chunk:GetExtentsSize().Z - 0.1 -- Offset to avoid small spaces between chunks

		-- Spawn chunks
		for i = 1, CHUNKS_COUNT do
			table.insert(Chunks, Chunk:new(startingPosition, i, zOffset))
		end
	end)
end

function EndlessRunnerController:OnStart()
	SpawnChunks()
end

function EndlessRunnerController:OnInit() end

return EndlessRunnerController
