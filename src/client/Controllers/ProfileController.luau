-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local TableUtil = require(Packages.TableUtil)

-- Variables
local PlayerDataController
local UserInterfaceController
local Interface

--
local ProfileController = {}

function ProfileController:OnStart()
	PlayerDataController = require(ReplicatedStorage.Client.Controllers.PlayerDataController)
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)

	Interface = UserInterfaceController:GetInterface("Profile")

	PlayerDataController:ObserveChange("Level", function(level: number)
		local xp: number = PlayerDataController:GetKey("Xp"):expect()
		Interface:SetLevelAndXp(level, xp)
	end)

	PlayerDataController:ObserveChange("DailyCheckInStreak", function(count: number)
		Interface:SetDailyCheckIns(count)
	end)

	PlayerDataController:ObserveChange("Xp", function(xp: number)
		local level: number = PlayerDataController:GetKey("Level"):expect()
		Interface:SetLevelAndXp(level, xp)
	end)

	PlayerDataController:ObserveChange("Journals", function(journals: table)
		Interface:SetJournals(#journals)
	end)

	PlayerDataController:ObserveChange("QuestionsAnswered", function(questions: table)
		Interface:SetQuestionsAnswered(#TableUtil.Keys(questions))
	end)

	PlayerDataController:ObserveChange("SelfAssessments", function(count: number)
		Interface:SetSelfAssessments(count)
	end)

	PlayerDataController:ObserveChange("MentorSessions", function(count: number)
		Interface:SetMentorSessions(count)
	end)

	PlayerDataController:ObserveChange("MinigameStats", function(stats: table)
		Interface:SetMinigameStats(stats)
	end)
end

return ProfileController
