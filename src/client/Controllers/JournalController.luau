-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)

-- References
local LocalPlayer = Players.LocalPlayer

-- Variables
local Interface: ScreenGui

local UserInterfaceController
local JournalService

--
local JournalController = {}

function JournalController:SubmitJournal() end

function JournalController:OnStart()
	UserInterfaceController = require(ReplicatedStorage.Client.Controllers.UserInterfaceController)
	JournalService = Cardinal.GetService("JournalService")

	local available: boolean = JournalService:JournalAvailable()
	print(`Journal Available: {available}`)

	Interface = UserInterfaceController:GetInterface("Journal")
end

return JournalController
