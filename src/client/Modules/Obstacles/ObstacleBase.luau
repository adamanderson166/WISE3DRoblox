-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

--
local ObstacleBase = {}
ObstacleBase.__index = ObstacleBase

function ObstacleBase:Init(obstacleModel: Model, position: Vector3, parent: Instance)
	self._trove = Trove.new()

	self._obstacle = obstacleModel:Clone()
	self._obstacle.Parent = parent
	self._obstacle:PivotTo(CFrame.new(position))

	self._trove:Add(self._obstacle)
end

function ObstacleBase:Clear()
	self._trove:Clean()
end

return ObstacleBase
