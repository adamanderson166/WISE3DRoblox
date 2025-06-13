-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

-- Constants
local ROTATION_SPEED = 80

--
local Coin = setmetatable({}, ObstacleBase)
Coin.__index = Coin

function Coin.New(coinModel: Model, location: Attachment, parent: Instance)
	local instance = setmetatable({}, Coin)
	instance:Init(coinModel, location.WorldCFrame.Position + Vector3.new(0, 1.5, 0), parent)

	-- Rotate the gear obstacle
	instance._trove:Add(RunService.Heartbeat:Connect(function(deltaTime: number)
		instance._obstacle:PivotTo(
			instance._obstacle:GetPivot() * CFrame.Angles(0, math.rad(ROTATION_SPEED) * deltaTime, 0)
		)
	end))

	return instance
end

function Coin:Destroy()
	self:Clear()
end

return Coin
