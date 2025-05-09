-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

-- Modules
local Chunk = require(ReplicatedStorage.Client.Modules.Chunk)

-- References
local Player: Player = Players.LocalPlayer

-- Constants
local CHUNKS_COUNT = 30
local CHUNK_MOVEMENT_SPEED = 20
local CHUNK_RECYCLE_THRESHOLD = 70
local RUN_ANIM = "rbxassetid://2510198475"

local MOVE_LEFT_KEYCODES = {
	Enum.KeyCode.A,
	Enum.KeyCode.Left,
	Enum.KeyCode.ButtonL1,
}

local MOVE_RIGHT_KEYCODES = {
	Enum.KeyCode.D,
	Enum.KeyCode.Right,
	Enum.KeyCode.ButtonR1,
}

-- Variables
local Interface
local CharacterController
local UserInterfaceController

local ChunksList: { table } = {}
local CurrentLane: number = 0
local PlayerLanes: { string: Vector3 } = {
	[1] = Vector3.zero,
	[2] = Vector3.zero,
	[3] = Vector3.zero,
}

--
local EndlessRunnerController = {}

function EndlessRunnerController:PopulateChunks()
	-- Populate the chunks with obstacles and environment objects, skip the first two chunks so players dont run into them right away
end

function EndlessRunnerController:MoveChunks()
	if #ChunksList == 0 then
		warn("No chunks spawned!")
		return
	end

	local threshold: number = (
		ChunksList[1]:GetModel():GetPivot().Position - Vector3.new(0, 0, CHUNK_RECYCLE_THRESHOLD)
	).Z

	-- Move chunks down the Z-axis and check for recycling
	self._trove:Add(RunService.Heartbeat:Connect(function(deltaTime: number)
		for _, chunk: table in ipairs(ChunksList) do
			local model: Model = chunk:GetModel()
			model:PivotTo(model:GetPivot() + Vector3.new(0, 0, -CHUNK_MOVEMENT_SPEED * deltaTime))
		end

		-- Recycle the first chunk when it crosses threshold behind the player
		if ChunksList[1]:GetModel():GetPivot().Position.Z < threshold then
			-- Remove the chunk from the list and clear it
			local recycledChunk = table.remove(ChunksList, 1)
			recycledChunk:Clear()

			recycledChunk:MoveToStepFromPosition(ChunksList[#ChunksList]:GetModel():GetPivot().Position, 1)
			table.insert(ChunksList, recycledChunk)
		end
	end))
end

function EndlessRunnerController:SpawnChunks()
	task.spawn(function()
		local chunkRef: Model = ReplicatedStorage.Assets.EndlessRunner:WaitForChild("Chunk", 5)

		local startingPosition: Vector3 = chunkRef:GetPivot().Position

		local chunkLength: number = chunkRef.MiddlePath.Size.Z - 0.1 -- Offset to avoid small spaces between chunks

		-- Spawn chunks
		for i = 1, CHUNKS_COUNT do
			table.insert(ChunksList, Chunk:New(startingPosition, i, chunkLength))
		end
	end)
end

function EndlessRunnerController:ListenToInput()
	self._trove:Add(UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then
			return
		end

		if table.find(MOVE_LEFT_KEYCODES, input.KeyCode) then
			-- Move player left
			if CurrentLane > 1 then
				CurrentLane = CurrentLane - 1

				CharacterController:MoveToLocation(
					CFrame.new(PlayerLanes[CurrentLane]) * CFrame.Angles(0, math.rad(180), 0),
					true
				)
			end
		elseif table.find(MOVE_RIGHT_KEYCODES, input.KeyCode) then
			-- Move player right
			if CurrentLane < 3 then
				CurrentLane = CurrentLane + 1

				CharacterController:MoveToLocation(
					CFrame.new(PlayerLanes[CurrentLane]) * CFrame.Angles(0, math.rad(180), 0),
					true
				)
			end
		end
	end))
end

function EndlessRunnerController:StartEndlessRunner()
	self:SpawnChunks()

	local character: Model = Player.Character or Player.CharacterAdded:Wait()

	PlayerLanes[1] = ChunksList[1]:GetModel().LeftPath.Front.WorldCFrame.Position
		+ Vector3.new(0, 0, 2)
		+ Vector3.new(0, character:GetExtentsSize().Y / 2, 0)

	PlayerLanes[2] = ChunksList[1]:GetModel().MiddlePath.Front.WorldCFrame.Position
		+ Vector3.new(0, 0, 2)
		+ Vector3.new(0, character:GetExtentsSize().Y / 2, 0)

	PlayerLanes[3] = ChunksList[1]:GetModel().RightPath.Front.WorldCFrame.Position
		+ Vector3.new(0, 0, 2)
		+ Vector3.new(0, character:GetExtentsSize().Y / 2, 0)

	CurrentLane = 2 -- Middle lane

	-- Position Player on the first chunk and disable controls
	CharacterController:ToggleControls(false)

	local cFrame: CFrame = (CFrame.new(PlayerLanes[CurrentLane])) * CFrame.Angles(0, math.rad(180), 0)

	character:PivotTo(cFrame)

	self:PopulateChunks()

	UserInterfaceController:ShowInterface("Runner")

	-- Display a countdown then start the game
	Interface:StartCountdown(3):andThen(function()
		CharacterController:PlayAnimation(RUN_ANIM)

		self:MoveChunks()

		self:ListenToInput()
	end)
end

function EndlessRunnerController:OnStart()
	CharacterController = require(ReplicatedStorage.Client.Controllers.CharacterController)
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)

	Interface = UserInterfaceController:GetInterface("Runner")

	task.delay(2, function()
		self:StartEndlessRunner()
	end)
end

function EndlessRunnerController:OnInit()
	self._trove = Trove.new()
end

return EndlessRunnerController
