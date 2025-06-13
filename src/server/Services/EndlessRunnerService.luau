-- Services
local PhysicsService = game:GetService("PhysicsService")

PhysicsService:RegisterCollisionGroup("Player")
PhysicsService:RegisterCollisionGroup("Obstacle")
PhysicsService:CollisionGroupSetCollidable("Player", "Obstacle", true)

--
local EndlessRunnerService = {}

function EndlessRunnerService:OnStart() end

function EndlessRunnerService:OnInit() end

return EndlessRunnerService
