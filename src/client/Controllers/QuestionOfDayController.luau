-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)
local TableUtil = require(Packages.TableUtil)

-- Modules
local QuestionData = require(ReplicatedStorage.Client.Modules.QuestionData)

-- Variables
local UserInterfaceController
local QuestionOfDayService
local PlayerDataController
local NotificationController

local Interface
local CurrentQuestion: table
local CorrectAnswerIndex: number

--
local QuestionOfDayController = {}

function QuestionOfDayController:DisplayRandomQuestion()
	local questions: table = PlayerDataController:GetKey("QuestionsAnswered"):expect()

	-- Get ids of already answered questions
	local alreadyAnswered: table = TableUtil.Keys(questions)

	-- Filter out already answered questions
	local availableQuestions: table = TableUtil.Filter(QuestionData:GetData(), function(question: table)
		for _, answeredId in ipairs(alreadyAnswered) do
			if question.Id == answeredId then
				return false
			end
		end

		return true
	end)

	-- All questions have been answered
	if #availableQuestions == 0 then
		QuestionOfDayService:ResetQuestionsAnswered():await()
		availableQuestions = QuestionData:GetData()
	end

	local randomQuestion: table = availableQuestions[math.random(1, #availableQuestions)]

	-- Get two random wrong answers from the question data
	local wrongAnswers: { string } = QuestionData:GetTwoRandomWrongAnswersFromQuestion(randomQuestion)

	if not wrongAnswers then
		warn("No wrong answers found for question: ", randomQuestion.Id)
		return
	end

	CurrentQuestion = {}
	CurrentQuestion.Answers = {}

	CurrentQuestion.Id = randomQuestion.Id
	CurrentQuestion.Question = randomQuestion.Question

	-- Create a random order of displaying answers on UI (including the correct answer)
	local randomOrder: { number } = TableUtil.Shuffle({ 1, 2, 3 })

	CorrectAnswerIndex = randomOrder[1]

	CurrentQuestion.Answers[randomOrder[1]] = randomQuestion.CorrectAnswer
	CurrentQuestion.Answers[randomOrder[2]] = randomQuestion.WrongAnswers[1]
	CurrentQuestion.Answers[randomOrder[3]] = randomQuestion.WrongAnswers[2]

	Interface:DisplayQuestion(CurrentQuestion)
	Interface:Show()
end

function QuestionOfDayController:SubmitAnswer(index: number)
	local correct: boolean = index == CorrectAnswerIndex

	QuestionOfDayService:SubmitQuestion(CurrentQuestion.Id, correct)

	Interface:Hide()
end

function QuestionOfDayController:AttemptQuestion()
	local questionAvailable: boolean = QuestionOfDayService:QuestionAvailable()

	if questionAvailable then
		self:DisplayRandomQuestion()
	else
		NotificationController:Notify("You have already submitted a question for today.")
	end
end

function QuestionOfDayController:OnStart()
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)
	PlayerDataController = require(ReplicatedStorage.Client.Controllers.PlayerDataController)
	NotificationController = require(ReplicatedStorage.Client.Controllers.NotificationController)
	QuestionOfDayService = Cardinal.GetService("QuestionOfDayService")

	Interface = UserInterfaceController:GetInterface("QuestionOfDay")

	local questionAvailable: boolean = QuestionOfDayService:QuestionAvailable()

	if questionAvailable then
		self:DisplayRandomQuestion()
	end
end

return QuestionOfDayController
