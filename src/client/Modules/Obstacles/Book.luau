-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Book = setmetatable({}, ObstacleBase)
Book.__index = Book

function Book.New(bookModel: Model, position: Vector3, parent: Instance)
	local instance = setmetatable({}, Book)
	instance:Init(bookModel, position, parent)
	return instance
end

function Book:Destroy()
	self:Clear()
end

return Book
