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
local CHUNK_RECYCLE_THRESHOLD = 70
local RUN_ANIM = "rbxassetid://2510198475"
local JUMP_ANIM = "rbxassetid://2510197830"

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
local CameraController
local SoundController

local ChunksList: { table } = {}
local TargetCFrame: CFrame = nil
local PreviousLane: number = 0
local CurrentLane: number = 0
local Coins: number = 0
local SwitchingLanes: boolean = false
local PlayerLanes: { string: Vector3 } = {
	[1] = Vector3.zero,
	[2] = Vector3.zero,
	[3] = Vector3.zero,
}
local Multipliers: { string: number } = {
	Distance = 10,
	Score = 1,
	Chunk = 25,
}
local GameEnded: boolean = false

--
local EndlessRunnerController = {}

function EndlessRunnerController:PopulateChunks()
	-- Populate the chunks with obstacles and environment objects, skip the first two chunks so players dont run into them right away

	for index: number, chunk: table in ipairs(ChunksList) do
		if index > 2 then
			chunk:Populate()
		end
	end
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
	self._trove:Add(RunService.RenderStepped:Connect(function(deltaTime: number)
		if GameEnded then
			return
		end

		for _, chunk: table in ipairs(ChunksList) do
			local model: Model = chunk:GetModel()
			model:PivotTo(model:GetPivot() + Vector3.new(0, 0, -Multipliers.Chunk * deltaTime))
		end

		-- Recycle the first chunk when it crosses threshold behind the player
		if ChunksList[1]:GetModel():GetPivot().Position.Z < threshold then
			if GameEnded then
				return
			end

			-- Remove the chunk from the list and clear it
			local recycledChunk = table.remove(ChunksList, 1)
			recycledChunk:Clear()

			recycledChunk:MoveToStepFromPosition(ChunksList[#ChunksList]:GetModel():GetPivot().Position, 1)
			recycledChunk:Populate()
			table.insert(ChunksList, recycledChunk)
		end
	end))
end

function EndlessRunnerController:SpawnChunks()
	local chunkRef: Model = workspace.EndlessRunner:WaitForChild("Chunk", 5)

	local startingPosition: Vector3 = chunkRef:GetPivot().Position

	local chunkLength: number = chunkRef.MiddlePath.Size.Z - 0.1 -- Offset to avoid small spaces between chunks

	-- Spawn chunks
	for i = 1, CHUNKS_COUNT do
		table.insert(ChunksList, Chunk:New(startingPosition, i, chunkLength))
	end
end

function EndlessRunnerController:ListenToInput()
	self._trove:Add(UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Space then
			CharacterController:Jump()
		end

		if SwitchingLanes then
			return
		end

		if table.find(MOVE_LEFT_KEYCODES, input.KeyCode) then
			-- Move player left
			if CurrentLane > 1 then
				CurrentLane = CurrentLane - 1
			end
		elseif table.find(MOVE_RIGHT_KEYCODES, input.KeyCode) then
			-- Move player right
			if CurrentLane < 3 then
				CurrentLane = CurrentLane + 1
			end
		end

		if CurrentLane ~= PreviousLane then
			-- Move the player to the new lane
			TargetCFrame = CFrame.new(PlayerLanes[CurrentLane]) * CFrame.Angles(0, math.rad(180), 0)
			PreviousLane = CurrentLane
			SwitchingLanes = true
			--CharacterController:PlayAnimation(JUMP_ANIM)
			--CharacterController:Jump()
		end
	end))
end

function EndlessRunnerController:SetupLanes()
	local character: Model = Player.Character or Player.CharacterAdded:Wait()

	PlayerLanes[1] = ChunksList[2]:GetModel().LeftPath.Front.WorldCFrame.Position
		+ Vector3.new(0, 0, 2)
		+ Vector3.new(0, character:GetExtentsSize().Y / 2, 0)

	PlayerLanes[2] = ChunksList[2]:GetModel().MiddlePath.Front.WorldCFrame.Position
		+ Vector3.new(0, 0, 2)
		+ Vector3.new(0, character:GetExtentsSize().Y / 2, 0)

	PlayerLanes[3] = ChunksList[2]:GetModel().RightPath.Front.WorldCFrame.Position
		+ Vector3.new(0, 0, 2)
		+ Vector3.new(0, character:GetExtentsSize().Y / 2, 0)

	CurrentLane = 2 -- Middle lane
	PreviousLane = 2

	TargetCFrame = (CFrame.new(PlayerLanes[CurrentLane])) * CFrame.Angles(0, math.rad(180), 0)
	character:PivotTo(TargetCFrame)

	-- Update player position depending on the current lane and if targetCFrame is set
	self._trove:Add(RunService.RenderStepped:Connect(function(deltaTime: number)
		if not TargetCFrame then
			return
		end

		local characterCFrame: CFrame = character:GetPivot()
		local targetCFrame: CFrame = characterCFrame:Lerp(TargetCFrame, 0.05)
		character:PivotTo(targetCFrame)

		-- Player reached the target position
		if (characterCFrame.Position - TargetCFrame.Position).Magnitude < 1 then
			TargetCFrame = nil

			if SwitchingLanes then
				--CharacterController:PlayAnimation(RUN_ANIM)
			end

			SwitchingLanes = false
		end
	end))
end

function EndlessRunnerController:TimeLoop()
	-- Set up timers for score and distance multipliers
	local timers: { number } = {
		Score = tick(),
		Distance = tick(),
	}

	self._trove:Add(RunService.RenderStepped:Connect(function()
		if tick() - timers.Distance > 20 then
			Multipliers.Distance += 1
			Multipliers.Chunk += 3

			timers.Distance = tick()
		end

		-- We might need to adjust the score multiplier based on game design later
		if tick() - timers.Score > 50 then
			Multipliers.Score += 1
			Interface:SetScoreMultiplier(Multipliers.Score)
			timers.Score = tick()
		end

		--[[
			local minutes: number = math.floor(elapsedTime / 60)
			local seconds: number = math.floor(elapsedTime % 60)
			Interface:SetTime(string.format("%02d:%02d", minutes, seconds))
		]]
	end))
end

function EndlessRunnerController:CalculateDistanceAndScore()
	local distanceTraveled: number = 0
	local score: number = 0

	self._trove:Add(RunService.Heartbeat:Connect(function(deltaTime: number)
		distanceTraveled += deltaTime * Multipliers.Distance
		score += deltaTime * Multipliers.Score

		Interface:SetDistanceTraveled(math.floor(distanceTraveled))
		Interface:SetScore(math.floor(score))
	end))
end

function EndlessRunnerController:CoinCollected()
	Coins += 1
	Interface:SetCoins(Coins)

	SoundController:Play("CoinCollected")
end

function EndlessRunnerController:StartGame()
	CharacterController:ToggleControls(false)

	UserInterfaceController:Fade(true, 1):await()

	self:SpawnChunks()
	self:SetupLanes()
	self:PopulateChunks()

	CameraController:FollowTargetWithOffset(
		Player.Character.PrimaryPart,
		-Player.Character.PrimaryPart.CFrame.LookVector,
		Vector3.new(0, 8, -15)
	)

	Interface:Show()
	Interface:ToggleStats(true)

	task.wait(3)

	UserInterfaceController:Fade(false, 2):await()

	-- Display a countdown then start the game
	Interface:StartCountdown(3):andThen(function()
		self:MoveChunks()
		self:CalculateDistanceAndScore()
		self:TimeLoop()
		self:ListenToInput()

		CharacterController:PlayAnimation(RUN_ANIM)
	end)
end

function EndlessRunnerController:StopGame()
	GameEnded = true

	UserInterfaceController:Fade(true, 1):await()

	task.wait(1)

	UserInterfaceController:Fade(false, 1)

	CharacterController:ToggleControls(true)
	CharacterController:StopAnimation()
	CharacterController:MoveToLocation(workspace:FindFirstChild("SpawnLocation").CFrame * CFrame.new(0, 5, 0))

	CameraController:FocusCameraOnPlayer()

	self._trove:Clean()

	for _, chunk: table in ipairs(ChunksList) do
		chunk:Destroy()
	end

	ChunksList = {}

	Interface:Hide()
	Interface:ToggleStats(false)

	UserInterfaceController:ShowInterface("Hud")
end

function EndlessRunnerController:OnStart()
	CharacterController = require(ReplicatedStorage.Client.Controllers.CharacterController)
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)
	CameraController = require(ReplicatedStorage.Client.Controllers.CameraController)
	SoundController = require(ReplicatedStorage.Client.Controllers.SoundController)

	Interface = UserInterfaceController:GetInterface("Runner")
end

function EndlessRunnerController:OnInit()
	self._trove = Trove.new()
end

return EndlessRunnerController
