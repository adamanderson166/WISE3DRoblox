local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cardinal = require(ReplicatedStorage.Packages.Cardinal)

Cardinal.Load(ServerStorage.Server.Services)

Cardinal.Start():andThen(function() 
    print("Server Loaded")
end)