--
local ObstacleBase = {}
ObstacleBase.__index = ObstacleBase

function ObstacleBase:Init(obstacleModel: Model, position: Vector3) end

function ObstacleBase:Clear() end

return ObstacleBase
