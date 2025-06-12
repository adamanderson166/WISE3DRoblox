-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Log = setmetatable({}, ObstacleBase)
Log.__index = Log

function Log.New(logModel: Model, location: Attachment, parent: Instance)
	local instance = setmetatable({}, Log)
	instance:Init(logModel, location.WorldCFrame.Position, parent)
	return instance
end

function Log:Destroy()
	self:Clear()
end

return Log
