-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

-- Variables
local EndlessRunnerController

--
local ObstacleBase = {}
ObstacleBase.__index = ObstacleBase

function ObstacleBase:Init(obstacleModel: Model, position: Vector3, parent: Instance)
	EndlessRunnerController = require(ReplicatedStorage.Client.Controllers.EndlessRunnerController)

	self._trove = Trove.new()

	self._obstacle = obstacleModel:Clone()
	self._obstacle.Parent = parent
	self._obstacle:PivotTo(CFrame.new(position))

	self._trove:Add(self._obstacle)
end

function ObstacleBase:StopGame()
	EndlessRunnerController:StopGame(true)
end

function ObstacleBase:Clear()
	self._trove:Clean()
end

return ObstacleBase
