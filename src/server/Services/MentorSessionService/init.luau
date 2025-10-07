-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

-- Variables
local PlayerDataService

-- Constants
local SECONDS_IN_A_DAY = 86400

--
local MentorSessionService = {
	Client = {},
}

function MentorSessionService:MentorSessionAvailable(player: Player, mentorName: string)
	local replica = PlayerDataService:Get(player, 5):expect()

	if not replica then
		return
	end

	local available: boolean = false
	local data: table = replica.Data:Get()

	local mentorData: table = data.MentorSessions[mentorName]

	-- If no mentor data, it means the player has never had a mentor session
	if not mentorData then
		available = true
	else
		local currentTime: number = os.time()
		local timeDifferenceInDays: number = math.floor((currentTime - mentorData.TimeStamp) / SECONDS_IN_A_DAY)

		-- Player came back after a day or more
		if timeDifferenceInDays >= 1 then
			available = true
		else
			-- Player checked in today, so no question available
			available = false
		end
	end

	return available
end

function MentorSessionService.Client:MentorSessionAvailable(player: Player, mentorName: string)
	return self.Server:MentorSessionAvailable(player, mentorName)
end

function MentorSessionService.Client:SetMentorSession(player: Player, mentorName: string, progress: number)
	PlayerDataService:SetMentorSession(player, mentorName, progress, os.time())
end

function MentorSessionService:OnStart()
	PlayerDataService = require(ServerStorage.Server.Services.PlayerDataService)
end

return MentorSessionService
