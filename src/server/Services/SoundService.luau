-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")

-- Packages
local Packages = ReplicatedStorage.Packages
local TableUtil = require(Packages.TableUtil)
local Cardinal = require(Packages.Cardinal)

--
local SoundService = {
	Client = {
		PlaySound = Cardinal.CreateSignal(),
	},
}

function SoundService.Client:Play(player: Player, soundName: string, data: table, forExcept: boolean) -- forExcept means play for everyone except the player
	local players: { Player } = forExcept
			and TableUtil.Filter(PlayerService:GetPlayers(), function(value, _)
				return value.UserId ~= player.UserId
			end)
		or PlayerService:GetPlayers()

	SoundService.Client.PlaySound:Fire(players, soundName, data)
end

return SoundService
