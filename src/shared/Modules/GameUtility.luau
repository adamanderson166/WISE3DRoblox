--
local GameUtility = {}

function GameUtility:SetCollisionGroup(instance: Instance, groupName: string, deep: boolean)
	if not instance or not groupName then
		warn("Either instance or groupName is nil to set collision group.")
		return
	end

	if deep then
		for _, child: Instance in ipairs(instance:GetDescendants()) do
			if child:IsA("BasePart") then
				child.CollisionGroup = groupName
			end
		end
	else
		if instance:IsA("BasePart") then
			instance.CollisionGroup = groupName
		end
	end
end

return GameUtility
