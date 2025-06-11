-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Log = setmetatable({}, ObstacleBase)
Log.__index = Log

function Log.New(logModel: Model, position: Vector3, parent: Instance)
	local instance = setmetatable({}, Log)
	instance:Init(logModel, position, parent)
	return instance
end

function Log:Destroy()
	self:Clear()
end

return Log
