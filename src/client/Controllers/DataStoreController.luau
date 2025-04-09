local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Replicator = require(ReplicatedStorage.Packages.Replicator).Client

local Controller = {}

function Controller:OnStart()
    Replicator.ListenToNewReplica("PlayerData", function(Replica)
        print("New Replica", Replica)
    end)
end

return Controller