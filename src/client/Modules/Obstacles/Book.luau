-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

-- Constants
local HOVER_HEIGHT = 2
local HOVER_SPEED = 2

--
local Book = setmetatable({}, ObstacleBase)
Book.__index = Book

function Book.New(bookModel: Model, position: Vector3, parent: Instance)
	local instance = setmetatable({}, Book)

	-- Creating final position for the book obstacle in order to hover above the spawn location
	local finalPos: Vector3 = position + Vector3.new(0, bookModel:GetBoundingBox().Y / 3, 0)
	instance:Init(bookModel, finalPos, parent)

	local time: number = 0
	local offset: CFrame = CFrame.new(finalPos):ToObjectSpace(instance._obstacle.Parent.Parent:GetPivot())

	-- Hover the book obstacle
	instance._trove:Add(RunService.Heartbeat:Connect(function(deltaTime: number)
		time = time + deltaTime
		local offsetY: number = math.sin(time * HOVER_SPEED) * HOVER_HEIGHT

		local baseCFrame: CFrame = instance._obstacle.Parent.Parent:GetPivot() * offset

		instance._obstacle:PivotTo(baseCFrame * CFrame.new(Vector3.new(0, offsetY, 0)))
	end))

	return instance
end

function Book:Destroy()
	self:Clear()
end

return Book
