-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Crate = setmetatable({}, ObstacleBase)
Crate.__index = Crate

function Crate.New(crateModel: Model, location: Attachment, parent: Instance)
	local instance = setmetatable({}, Crate)
	instance:Init(crateModel, location.WorldCFrame.Position + Vector3.new(0, 1, 0), parent)
	return instance
end

function Crate:Destroy()
	self:Clear()
end

return Crate
