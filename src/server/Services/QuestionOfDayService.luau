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
local QuestionOfDayService = {
	Client = {},
}

function QuestionOfDayService:QuestionAvailable(player: Player)
	local replica = PlayerDataService:Get(player, 5):expect()

	if not replica then
		return
	end

	local available: boolean = false
	local data: table = replica.Data:Get()

	local LastQuestionTimeStamp: number = data.LastQuestionTimeStamp

	-- If LastQuestionTimeStamp is 0, it means the player has never answered a question
	if LastQuestionTimeStamp == 0 then
		available = true
	else
		local currentTime: number = os.time()
		local timeDifferenceInDays: number = math.floor((currentTime - LastQuestionTimeStamp) / SECONDS_IN_A_DAY)

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

function QuestionOfDayService.Client:QuestionAvailable(player: Player)
	return self.Server:QuestionAvailable(player)
end

function QuestionOfDayService.Client:SubmitQuestion(player: Player, questionId: number, correct: boolean)
	PlayerDataService:SetQuestionAnswered(player, questionId, correct, os.time())
end

function QuestionOfDayService.Client:ResetQuestionsAnswered(player: Player)
	PlayerDataService:ResetQuestionsAnswered(player)
end

function QuestionOfDayService:OnStart()
	PlayerDataService = require(ServerStorage.Server.Services.PlayerDataService)
end

return QuestionOfDayService
