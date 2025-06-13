-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local GameUtility = require(ReplicatedStorage.Shared.Modules.GameUtility)

--
local CharacterService = {}

function CharacterService:OnCharacterAdded(character: Model, player: Player)
	GameUtility:SetCollisionGroup(character, "Player", true)
end

return CharacterService
