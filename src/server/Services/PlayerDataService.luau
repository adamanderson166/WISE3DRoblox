--!strict
--!optimize 2

-- Services
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local DataKeep = require(ServerStorage.Packages.DataKeep)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Replicator = require(ReplicatedStorage.Packages.Replicator)

local Store
local Template = {
	Level = 0,
	Xp = 0,
}

type Replica = {
	[unknown]: unknown,
	Data: typeof(table.clone(Template)),
	Destroy: (Replica) -> (),
}

local Replicas: { [Player]: Replica } = {}

--
local PlayerDataService = {}

function PlayerDataService:OnInit()
	Store = DataKeep.GetStore("PlayerData", Template, {}):expect()

	if RunService:IsStudio() then -- Causes the Data in Studio to be "fresh" i.e Mock data
		Store = Store.Mock
	end
end

function PlayerDataService:OnPlayerAdded(Player: Player)
	local UserId = if Player.UserId > 0 then Player.UserId else 4062748404 -- stupid use case for studio testing (you can change this if you choose)

	Store:LoadKeep(`User_{UserId}`):andThen(function(Keep)
		if Keep == nil then
			Player:Kick("Data locked")
			return
		end

		Keep:Reconcile()
		Keep:AddUserId(UserId)

		if not Player:IsDescendantOf(game) then
			Keep:Release()
			return
		end

		local Replica = Replicator.NewReplica({
			Name = "PlayerData",
			Data = Keep.Data,
			To = Player,
		})

		Replica:AddCleanupMethod(function()
			Keep:Release()
		end)

		Replicas[Player] = Replica
	end)
end

function PlayerDataService:Get(Player: Player, Async: number?)
	local Replica = Replicas[Player]

	return if not Async
		then Replica
		else Promise.new(function(Resolve, Reject)
			if Replica then
				return Resolve(Replica)
			end

			local Start = tick()

			repeat
				Replica = Replicas[Player]
				task.wait()
			until Replica or tick() - Start >= Async

			return if not Replica then Reject("Timed out trying to find player's Replica") else Resolve(Replica)
		end)
end

function PlayerDataService:OnPlayerRemoving(Player: Player)
	local Replica: Replica = Replicas[Player]

	if Replica then
		Replica:Destroy()
		Replicas[Player] = nil
	end
end

return PlayerDataService
