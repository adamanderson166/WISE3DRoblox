-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Log = setmetatable({}, ObstacleBase)
Log.__index = Log

function Log.New(logModel: Model, location: Attachment, parent: Instance)
	local instance = setmetatable({}, Log)
	instance:Init(logModel, location.WorldCFrame.Position + Vector3.new(0, 1, 0), parent)

	local base: BasePart = instance.Obstacle:WaitForChild("Base", 5)

	if not base then
		return
	end

	instance.Trove:Add(base.Touched:Once(function(hit: BasePart)
		local humanoid: Humanoid = hit:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")

		if humanoid then
			instance:StopGame()
		end
	end))

	return instance
end

function Log:Destroy()
	self:Clear()
end

return Log
