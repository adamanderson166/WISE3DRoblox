-- Services
local ServerStorage = game:GetService("ServerStorage")
local PhysicsService = game:GetService("PhysicsService")

PhysicsService:RegisterCollisionGroup("Player")
PhysicsService:RegisterCollisionGroup("Obstacle")
PhysicsService:CollisionGroupSetCollidable("Player", "Obstacle", true)

-- Variables
local PlayerDataService

--
local EndlessRunnerService = {
	Client = {},
}

function EndlessRunnerService.Client:SetMinigameStats(
	player: Player,
	stats: {
		Runs: number,
		Score: number,
		Deaths: number,
		Distance: number,
	}
)
	PlayerDataService:SetMinigameStats(player, stats)
end

function EndlessRunnerService:OnStart()
	PlayerDataService = require(ServerStorage.Server.Services.PlayerDataService)
end

return EndlessRunnerService
