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

	self.Trove = Trove.new()

	self.Obstacle = obstacleModel:Clone()
	self.Obstacle.Parent = parent
	self.Obstacle:PivotTo(CFrame.new(position))

	self.Trove:Add(self.Obstacle)
end

function ObstacleBase:StopGame()
	EndlessRunnerController:StopGame(true)
end

function ObstacleBase:Clear()
	self.Trove:Clean()
end

return ObstacleBase
