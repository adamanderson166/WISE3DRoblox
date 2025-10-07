-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

-- Constants
local ROTATION_SPEED = 80

-- Variables
local EndlessRunnerController

--
local Coin = setmetatable({}, ObstacleBase)
Coin.__index = Coin

function Coin.New(coinModel: Model, location: Attachment, parent: Instance)
	EndlessRunnerController = require(ReplicatedStorage.Client.Controllers.EndlessRunnerController)

	local instance = setmetatable({}, Coin)
	instance:Init(coinModel, location.WorldCFrame.Position + Vector3.new(0, 1.5, 0), parent)

	-- Rotate the gear obstacle
	instance.Trove:Add(RunService.Heartbeat:Connect(function(deltaTime: number)
		instance.Obstacle:PivotTo(
			instance.Obstacle:GetPivot() * CFrame.Angles(0, math.rad(ROTATION_SPEED) * deltaTime, 0)
		)
	end))

	local base: BasePart = instance.Obstacle:WaitForChild("Base", 5)

	if not base then
		return
	end

	instance.Trove:Add(base.Touched:Once(function(hit: BasePart)
		local humanoid: Humanoid = hit:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")

		if humanoid then
			EndlessRunnerController:CoinCollected()
			instance:Destroy()
		end
	end))

	return instance
end

function Coin:Destroy()
	self:Clear()
end

return Coin
