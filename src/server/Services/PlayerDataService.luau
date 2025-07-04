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
	Level = 1,
	Xp = 100,
	DailyCheckInStreak = 0,
	LastCheckInTimeStamp = 0,
	QuestionsAnswered = {},
	LastQuestionTimeStamp = 0,
	SelfAssessments = 0,
	LastMentorSessionTimeStamp = 0,
	MentorSessions = {},
	Coins = 0,
	MinigameStats = {
		Runs = 0,
		HighScore = 0,
		Deaths = 0,
		MaxDistance = 0,
	},
	LastJournalSubmissionTimeStamp = 0,
	Journals = {},
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
	Store = DataKeep.GetStore("PlayerData_3", Template, {}):expect()

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

----------------------------------------------------------------------------------------------------------------

function PlayerDataService:UpdatePlayerStreak(player: Player, streakNumber: number, timeStamp: number)
	local replica: table = self:Get(player)
	replica.Data.DailyCheckInStreak = streakNumber
	replica.Data.LastCheckInTimeStamp = timeStamp
end

function PlayerDataService:SubmitJournal(player: Player, journal: string, timeStamp: number)
	local replica: table = self:Get(player)

	local journals: { [number]: { Date: string, Text: string } } = replica.Data:Get().Journals
	journals[#journals + 1] = { Date = os.date("%x"), Text = journal }

	replica.Data.Journals = journals
	replica.Data.LastJournalSubmissionTimeStamp = timeStamp
end

function PlayerDataService:SetCoins(player: Player, coins: number)
	local replica: table = self:Get(player)

	local currentCoins = replica.Data:Get().Coins + coins

	replica.Data.Coins = currentCoins
end

function PlayerDataService:SetQuestionAnswered(player: Player, questionId: string, correct: boolean, timeStamp: number)
	local replica: table = self:Get(player)

	local questionsAnswered: table = replica.Data:Get().QuestionsAnswered

	-- If the question has already been answered, do nothing
	-- Just in case the client tries to submit the same question multiple times
	if questionsAnswered[questionId] then
		return
	end

	questionsAnswered[questionId] = { Correct = correct }

	replica.Data.QuestionsAnswered = questionsAnswered
	replica.Data.LastQuestionTimeStamp = timeStamp
end

function PlayerDataService:ResetQuestionsAnswered(player: Player)
	local replica: table = self:Get(player)
	replica.Data.QuestionsAnswered = {}
end

function PlayerDataService:SetMinigameStats(
	player: Player,
	stats: {
		Runs: number,
		Score: number,
		Deaths: number,
		Distance: number,
	}
)
	local replica: table = self:Get(player)
	local currentStats = replica.Data:Get().MinigameStats

	currentStats.Runs += stats.Runs or 1
	currentStats.HighScore = math.max(currentStats.HighScore, stats.Score or 0)
	currentStats.Deaths += stats.Deaths or 0
	currentStats.MaxDistance = math.max(currentStats.MaxDistance, stats.Distance or 0)

	replica.Data.MinigameStats = currentStats
end

function PlayerDataService:SetMentorSession(player: Player, mentorName: string, progress: number, timeStamp: number)
	local replica: table = self:Get(player)

	local mentorSessions: { [string]: { Progress: number } } = replica.Data:Get().MentorSessions

	if not mentorSessions[mentorName] then
		mentorSessions[mentorName] = { Progress = 1, Count = 0 }
	end

	if mentorSessions[mentorName] then
		mentorSessions[mentorName].Count = mentorSessions[mentorName].Count + 1
	else
		mentorSessions[mentorName].Count = 1
	end

	replica.Data.MentorSessions = mentorSessions
	replica.Data.LastMentorSessionTimeStamp = timeStamp
end

return PlayerDataService
