-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Crate = setmetatable({}, ObstacleBase)
Crate.__index = Crate

function Crate.New(crateModel: Model, position: Vector3)
	local instance = setmetatable({}, Crate)
	instance:Init(crateModel, position)
end

return Crate
