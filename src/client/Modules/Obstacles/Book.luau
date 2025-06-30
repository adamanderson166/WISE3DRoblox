-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

-- Constants
local HOVER_HEIGHT = 1.5
local HOVER_SPEED = 2

--
local Book = setmetatable({}, ObstacleBase)
Book.__index = Book

function Book.New(bookModel: Model, location: Attachment, parent: Instance)
	local instance = setmetatable({}, Book)
	instance:Init(bookModel, location.WorldCFrame.Position, parent)

	local time: number = 0
	local extents: Vector3 = bookModel:GetExtentsSize()

	task.wait(math.random(1, 3)) -- Random delay to avoid all books moving in sync

	local randomOffset: number = math.random() * 2 * math.pi -- Random offset for the hover effect

	-- Hover the book obstacle
	instance._trove:Add(RunService.Heartbeat:Connect(function(deltaTime: number)
		time = time + deltaTime

		local offsetY: number = math.sin((time * HOVER_SPEED) + randomOffset) * HOVER_HEIGHT
		local currentPosition: Vector3 = instance._obstacle:GetPivot().Position

		local targetCFrame: CFrame = CFrame.new(
			Vector3.new(
				location.WorldCFrame.Position.X,
				location.WorldCFrame.Position.Y + extents.Y / 2,
				currentPosition.Z
			)
		)

		instance._obstacle:PivotTo(targetCFrame * CFrame.new(Vector3.new(0, offsetY, 0)))
	end))

	local base: BasePart = instance._obstacle:WaitForChild("Base", 5)

	if not base then
		return
	end

	instance._trove:Add(base.Touched:Once(function(hit: BasePart)
		local humanoid: Humanoid = hit:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")

		if humanoid then
			instance:StopGame()
		end
	end))

	return instance
end

function Book:Destroy()
	self:Clear()
end

return Book
