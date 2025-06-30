-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

-- Constants
local ROTATION_SPEED = 50

--
local Gear = setmetatable({}, ObstacleBase)
Gear.__index = Gear

function Gear.New(gearModel: Model, location: Attachment, parent: Instance)
	local instance = setmetatable({}, Gear)
	instance:Init(gearModel, location.WorldCFrame.Position, parent)

	-- Rotate the gear obstacle
	instance._trove:Add(RunService.Heartbeat:Connect(function(deltaTime: number)
		instance._obstacle:PivotTo(
			instance._obstacle:GetPivot() * CFrame.Angles(0, math.rad(ROTATION_SPEED) * deltaTime, 0)
		)
	end))

	local base: BasePart = instance._obstacle:WaitForChild("Base", 5)

	if not base then
		return
	end

	instance._trove:Add(base.Touched:Once(function(hit: BasePart)
		local humanoid: Humanoid = hit:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")

		if humanoid then
			instance:StopGame()
		end
	end))

	return instance
end

function Gear:Destroy()
	self:Clear()
end

return Gear
