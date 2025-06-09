-- Constants
local BASE_XP = 100
local GROWTH_FACTOR = 1.2

--
local LevelUtility = {}

function LevelUtility:GetLevelXp(level: number)
	return math.floor(BASE_XP * (GROWTH_FACTOR ^ (level - 1)))
end

function LevelUtility:GetTotalXpToReachLevel(targetLevel: number)
	local totalXp: number = 0

	for level: number = 1, targetLevel - 1 do
		totalXp += self:GetLevelXp(level)
	end

	return totalXp
end

return LevelUtility
