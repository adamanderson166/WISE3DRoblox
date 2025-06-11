-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Leaf = setmetatable({}, ObstacleBase)
Leaf.__index = Leaf

function Leaf.New(leafModel: Model, position: Vector3, parent: Instance)
	local instance = setmetatable({}, Leaf)
	instance:Init(leafModel, position, parent)
	return instance
end

function Leaf:Destroy()
	self:Clear()
end

return Leaf
