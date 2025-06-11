-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Book = setmetatable({}, ObstacleBase)
Book.__index = Book

function Book.New(bookModel: Model, position: Vector3)
	local instance = setmetatable({}, Book)
	instance:Init(bookModel, position)
end

return Book
