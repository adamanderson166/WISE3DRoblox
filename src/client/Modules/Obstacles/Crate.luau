-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Crate = setmetatable({}, ObstacleBase)
Crate.__index = Crate

function Crate.New(crateModel: Model, position: Vector3, parent: Instance)
	local instance = setmetatable({}, Crate)
	instance:Init(crateModel, position, parent)
	return instance
end

function Crate:Destroy()
	self:Clear()
end

return Crate
