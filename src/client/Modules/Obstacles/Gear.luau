-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Gear = setmetatable({}, ObstacleBase)
Gear.__index = Gear

function Gear.New(gearModel: Model, position: Vector3)
	local instance = setmetatable({}, Gear)
	instance:Init(gearModel, position)
end

return Gear
