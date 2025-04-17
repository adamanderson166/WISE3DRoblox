-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Replicator = require(Packages.Replicator)
local Promise = require(Packages.Promise)

--
local PlayerDataController = {}

function PlayerDataController:GetReplica()
	return Promise.new(function(resolve)
		if self._replica then
			resolve(self._replica)
		else
			Replicator.ListenToNewReplica("PlayerData", function(replica)
				self._replica = replica
				resolve(replica)
			end)
		end
	end)
end

function PlayerDataController:ListenToChange<T>(key: string, callback: (newValue: T) -> ())
	self:GetReplica():andThen(function(replica)
		replica:ListenToChange(key, callback)
	end)
end

function PlayerDataController:ObserveChange<T>(key: string, callback: (newValue: T) -> ())
	self:GetReplica():andThen(function(replica)
		replica:ObserveChange(key, callback)
	end)
end

function PlayerDataController:GetKey(key: string)
	return Promise.new(function(resolve)
		self:GetReplica():andThen(function(replica)
			resolve(replica.Data[key])
		end)
	end)
end

function PlayerDataController:OnInit()
	self:GetReplica()
end

return PlayerDataController
