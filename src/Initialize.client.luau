local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cardinal = require(ReplicatedStorage.Packages.Cardinal)

Cardinal.Load(ReplicatedStorage.Client.Controllers)

Cardinal.Start():andThen(function() 
    print("Client Loaded")
end)