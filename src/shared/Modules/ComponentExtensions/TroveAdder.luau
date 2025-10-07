-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)

--
local TroveAdder = {}

function TroveAdder.Constructing(component)
	component.Trove = Trove.new()
end

function TroveAdder.Stopped(component)
	component.Trove:Destroy()
end

return TroveAdder
