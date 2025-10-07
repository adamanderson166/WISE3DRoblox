-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

-- Constants
local DEBUG_POSITION = false

local COIN_PROBABILITY: { string: number } = {
	RemovedLane = 0.4, -- Probability of spawning a coin in the removed lane
	ChosenLanes = 0.2, -- Probability of spawning a coin in lanes with obstacles
}

-- Variables
local ObstacleModules = {}

--
for _, module: ModuleScript in ipairs(ReplicatedStorage.Client.Modules.Obstacles:GetChildren()) do
	ObstacleModules[module.Name] = require(module)
end

--
local Chunk = {}
Chunk.__index = Chunk

function Chunk:New(startingPosition: Vector3, step: number, length: number)
	local instance = {}
	setmetatable(instance, Chunk)

	instance.Length = length
	instance.Trove = Trove.new()

	-- Create a new instance of the Chunk model
	instance.Model = workspace.EndlessRunner.Chunk:Clone()
	instance.Model.Name = step
	instance.Model.Parent = workspace.EndlessRunner

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
	self.Model:PivotTo(CFrame.new(referencePosition + Vector3.new(0, 0, self.Length * (step and step or 0))))
end

function Chunk:GetModel()
	return self.Model
end

function Chunk:Populate()
	local function spawnCoinInLane(lane: string, location: string)
		if not location then
			warn("No location available to spawn coin in lane: " .. lane)
			return
		end

		local spawnLocation: Attachment = self.Model:FindFirstChild(lane .. "Path"):FindFirstChild(location)

		if not spawnLocation then
			warn("Center attachment not found in path: " .. lane .. "Path")
			return
		end

		local coin: Model = ReplicatedStorage.Assets.EndlessRunner.Obstacles.Coin
		self.Trove:Add(ObstacleModules["Coin"].New(coin, spawnLocation, self.Model.Obstacles))
	end

	-- Populate the instance with obstacles
	task.spawn(function()
		local laneNames: { string } = { "Left", "Middle", "Right" }

		local randomIndex: number = math.random(1, #laneNames)
		local removedLane: string = laneNames[randomIndex]

		table.remove(laneNames, randomIndex) -- Remove a random lane to ensure only two lanes are used

		local obstacles: { Model } = ReplicatedStorage.Assets.EndlessRunner.Obstacles:GetChildren()

		for i = 1, #laneNames do
			local path: BasePart = self.Model:FindFirstChild(laneNames[i] .. "Path")

			if not path then
				warn("Path not found for lane: " .. laneNames[i])
				continue
			end

			local spawnLocation: Attachment = path:FindFirstChild("Center")

			if not spawnLocation then
				warn("Center attachment not found in path: " .. path.Name)
				continue
			end

			-- Spawn the obstacle
			local randomObstacle: Model = obstacles[math.random(1, #obstacles)]
			local type: string = randomObstacle:GetAttribute("Type")

			if not type or not ObstacleModules[type] then
				warn(`Either type "{type}" is not set for the model or the module for type "{type}" does not exist.`)
				continue
			end

			--print(`Path : {path.Name} | Location : {spawnLocation} | Chunk : {self.Model.Name} | Obstacle : {type}`)

			local obstacle: table = ObstacleModules[type].New(randomObstacle, spawnLocation, self.Model.Obstacles)

			if obstacle then
				self.Trove:Add(obstacle)
			end
			-- Can use this to spawn coins in the lanes with obstacles but might not be necessary
			--[[
				-- Spawn coin in the lane with probability
				if math.random() < COIN_PROBABILITY.ChosenLanes then
					spawnCoinInLane(laneNames[i], math.random() < 0.5 and "Front" or "Rear")
				end
			]]
		end

		-- Spawn coin in the removed lane with probability
		if math.random() < COIN_PROBABILITY.RemovedLane then
			spawnCoinInLane(removedLane, "Center")
		end
	end)
end

function Chunk:Clear()
	self.Trove:Clean()
end

function Chunk:Destroy()
	self:Clear()

	if self.Model then
		self.Model:Destroy()
	end

	self.Model = nil
	self.Length = nil
end

return Chunk
