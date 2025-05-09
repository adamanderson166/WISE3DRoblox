-- Services
local Players = game:GetService("Players")

-- References
local Player: Player = Players.LocalPlayer

-- Variables
local PlayerModule

--
local Characterontroller = {}

function Characterontroller:OnStart()
	--PlayerModule = require(Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
	--PlayerModule:Disable()
end

return Characterontroller
