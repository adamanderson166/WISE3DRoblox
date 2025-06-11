-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

-- Constants
local HOVER_HEIGHT = 5
local HOVER_SPEED = 2

--
local Book = setmetatable({}, ObstacleBase)
Book.__index = Book

function Book.New(bookModel: Model, position: Vector3, parent: Instance)
	local instance = setmetatable({}, Book)

	instance:Init(bookModel, position, parent)

	local time: number = 0

	local offset: CFrame = instance._obstacle:GetPivot():ToObjectSpace(instance._obstacle.Parent.Parent:GetPivot())

	-- Hover the book obstacle
	instance._trove:Add(RunService.Heartbeat:Connect(function(deltaTime: number)
		time = time + deltaTime
		local offsetY: number = math.sin(time * HOVER_SPEED) * HOVER_HEIGHT

		instance._obstacle:PivotTo(
			instance._obstacle.Parent.Parent:GetPivot() * offset * CFrame.new(Vector3.new(0, offsetY, 0))
		)
	end))

	return instance
end

function Book:Destroy()
	self:Clear()
end

return Book
