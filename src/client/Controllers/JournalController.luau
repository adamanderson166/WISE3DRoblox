-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)

-- References
local JournalService

--
local JournalController = {}

function JournalController:SubmitJournal() end

function JournalController:OnStart()
	JournalService = Cardinal.GetService("JournalService")

	local available: boolean = JournalService:JournalAvailable()
	print(`Journal Available: {available}`)
end

return JournalController
