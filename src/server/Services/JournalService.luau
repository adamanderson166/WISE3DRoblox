-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

-- References
local PlayerDataService

-- Constants
local JOURNAL_AVAILABLE_DURATION = 18000

--
local JournalService = {
	Client = {},
}

function JournalService:JournalAvailable(player: Player)
	return Promise.new(function(resolve)
		PlayerDataService:Get(player, 5):andThen(function(replica: table)
			local journalAvailable: boolean = false

			local data: table = replica.Data:Get()

			local LastJournalSubmissionTimeStamp: number = data.LastJournalSubmissionTimeStamp

			-- First time submitting a journal
			if LastJournalSubmissionTimeStamp == 0 then
				journalAvailable = true
			else
				local currentTime: number = os.time()
				local timeDifferenceInSeconds: number = currentTime - LastJournalSubmissionTimeStamp

				-- Check if the time difference is greater than or equal to the available duration
				if timeDifferenceInSeconds >= JOURNAL_AVAILABLE_DURATION then
					journalAvailable = true
				end
			end

			resolve(journalAvailable)
		end)
	end)
end

function JournalService.Client:JournalAvailable(player: Player)
	return self.Server:JournalAvailable(player):expect()
end

function JournalService.Client:SubmitJournal(player: Player, journal: string)
	local journalAvailable: boolean = self.Server:JournalAvailable(player):expect()

	if not journalAvailable then
		return
	end

	PlayerDataService:UpdatePlayerJournal(player, journal, os.time())
end

function JournalService:OnStart()
	PlayerDataService = require(ServerStorage.Server.Services.PlayerDataService)
end

return JournalService
