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
	instance:Init(bookModel, position, parent)

	return instance
end

function Book:Destroy()
	self:Clear()
end

return Book
