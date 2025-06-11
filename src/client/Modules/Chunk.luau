-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

-- Constants
local DEBUG_POSITION = false

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

	instance._length = length
	instance._trove = Trove.new()

	-- Create a new instance of the Chunk model
	instance._model = workspace.EndlessRunner.Chunk:Clone()
	instance._model.Parent = workspace.EndlessRunner

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

function Chunk:PopulateObstacles()
	-- Populate the instance with obstacles
	task.spawn(function()
		local laneNames: { string } = { "Left", "Middle", "Right" }

		for i = 1, 2 do
			-- Generate a random lane
			local randomLane: number = math.random(1, #laneNames)

			local path: BasePart = self._model:FindFirstChild(laneNames[randomLane] .. "Path")

			if not path then
				warn("Path not found for lane: " .. laneNames[randomLane])
				continue
			end

			-- Remove the lane from the list to avoid duplicates
			table.remove(laneNames, randomLane)

			-- Generate a random spawn location within the path
			local locationNames: { string } = { "Center" } -- ignoring front and rear for now
			local randomLocation: number = math.random(1, #locationNames)

			local spawnLocation: Attachment = path:FindFirstChild(locationNames[randomLocation])

			if not spawnLocation then
				warn("Spawn location not found for lane: " .. locationNames[randomLane])
				continue
			end

			local obstacles: { Model } = ReplicatedStorage.Assets.EndlessRunner.Obstacles:GetChildren()

			local randomObstacle: Model = obstacles[math.random(1, #obstacles)]
			local type: string = randomObstacle:GetAttribute("Type")

			if not type or not ObstacleModules[type] then
				warn(`Either type "{type}" is not set for the model or the module for type "{type}" does not exist.`)
				continue
			end

			-- Create a new obstacle instance and add it to the trove
			self._trove:Add(
				ObstacleModules[type].New(
					randomObstacle:Clone(),
					spawnLocation.WorldCFrame.Position + Vector3.new(0, 1, 0),
					self._model.Obstacles
				)
			)

			-- Remove the location from the list to avoid duplicates
			table.remove(locationNames, randomLocation)
		end
	end)
end

function Chunk:ClearObstacles()
	self._trove:Clean()
end

function Chunk:Destroy()
	self:ClearObstacles()

	if self._model then
		self._model:Destroy()
	end

	self._trove = nil
	self._model = nil
	self._length = nil
end

return Chunk
