-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local ObstacleBase = require(ReplicatedStorage.Client.Modules.Obstacles.ObstacleBase)

--
local Leaf = setmetatable({}, ObstacleBase)
Leaf.__index = Leaf

function Leaf.New(leafModel: Model, location: Attachment, parent: Instance)
	local instance = setmetatable({}, Leaf)
	instance:Init(leafModel, location.WorldCFrame.Position, parent)

	instance._trove:Add(instance._obstacle.Base.Touched:Once(function(hit: BasePart)
		local humanoid: Humanoid = hit:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")

		if humanoid then
			instance:StopGame()
		end
	end))

	return instance
end

function Leaf:Destroy()
	self:Clear()
end

return Leaf
