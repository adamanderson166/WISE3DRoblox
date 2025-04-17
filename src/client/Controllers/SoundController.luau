-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Packages = ReplicatedStorage.Packages
local Cardinal = require(Packages.Cardinal)

-- Constants
local VALID_PROPERTIES = {
	"PlayOnRemove",
	"SoundId",
	"RollOffMaxDistance",
	"RollOffMinDistance",
	"RollOffMode",
	"Looped",
	"PlaybackSpeed",
	"Playing",
	"TimePosition",
	"Volume",
}

-- Variables
local SoundService

export type SoundData = {
	PlayOnRemove: boolean | nil,
	SoundId: string | number | nil,
	RollOffMaxDistance: number | nil,
	RollOffMinDistance: number | nil,
	RollOffMode: Enum.RollOffMode | nil,
	Looped: boolean | nil,
	PlaybackSpeed: number | nil,
	Playing: boolean | nil,
	TimePosition: number | nil,
	Volume: number | nil,
	Position: Vector3 | Instance | nil,
}

local SoundController = {
	Name = "SoundController",

	Sounds = {},
	Soundgroups = {},
	Loops = {},
}

local function CreateSoundGroup(Id: string)
	if not SoundController.Soundgroups[Id] then
		local Group = Instance.new("SoundGroup")
		Group.Name = Id

		SoundController.Soundgroups[Id] = Group

		Group.Parent = ReplicatedStorage

		return Group
	else
		return SoundController.Soundgroups[Id]
	end
end

function SoundController:Play(Id: string, Data: SoundData)
	local soundInstance = SoundController.Sounds[Id]

	Data = Data or {} :: SoundData

	if not soundInstance then
		warn("No sound instance for", Id)
		return
	end

	soundInstance = soundInstance:Clone()

	for Property, Value in pairs(Data) do
		if table.find(VALID_PROPERTIES, Property) then
			Instance[Property] = Value
		end
	end

	if Data.Position then
		local Position = Data.Position
		if typeof(Position) == "Instance" then
			Instance.Parent = Position

			if not Data.Looped then
				task.delay(Instance.TimeLength, function()
					if Instance and Instance.Parent then
						Instance:Destroy()
					end
				end)
			end
		elseif typeof(Position) == "CFrame" then
			Position = Position.Position
		end

		if typeof(Position) == "Vector3" then
			local Part = Instance.new("Part")
			Part.Anchored = true
			Part.CanCollide = false
			Part.CanTouch = false
			Part.CanQuery = false
			Part.Transparency = 1
			Part.Size = Vector3.new(0.01, 0.01, 0.01)
			Part:PivotTo(CFrame.new(Position))
			Part.Parent = workspace

			soundInstance.Parent = Part

			soundInstance.AncestryChanged:Connect(function()
				if not soundInstance or not soundInstance.Parent then
					Part:Destroy()
				end
			end)

			if not Data.Looped then
				task.delay(soundInstance.TimeLength, function()
					if Part and Part.Parent then
						Part:Destroy()
					end
				end)
			end
		end
	else
		soundInstance.Parent = workspace.CurrentCamera

		if not Data.Looped and not soundInstance.Looped then
			soundInstance.Ended:Once(function()
				if soundInstance and soundInstance.Parent then
					soundInstance:Destroy()
				end
			end)
		else
			-- Store clones of looped sounds in separate cache
			SoundController.Loops[Id] = soundInstance
		end
	end

	soundInstance:Play()

	return soundInstance
end

function SoundController:Stop(Id: string)
	if SoundController.Sounds[Id] then
		if SoundController.Sounds[Id].Looped then
			SoundController.Loops[Id]:Stop()
		else
			SoundController.Sounds[Id]:Stop()
		end
	end
end

function SoundController:Register(Sound: Sound, SoundGroup: string)
	SoundController.Sounds[Sound.Name] = Sound

	if SoundGroup then
		local SoundGroupInstance = CreateSoundGroup(SoundGroup)

		Sound.SoundGroup = SoundGroupInstance
	end
end

function SoundController:OnStart()
	SoundService = Cardinal.GetService("SoundService")

	for _, SoundGroupFolder in ipairs(ReplicatedStorage.Assets.Sounds:GetChildren()) do
		for _, Sound: Sound in ipairs(SoundGroupFolder:GetDescendants()) do
			if Sound:IsA("Sound") then
				self:Register(Sound, SoundGroupFolder.Name)
			end
		end
	end

	SoundService.PlaySound:Connect(function(id: string, data: SoundData)
		self:Play(id, data)
	end)
end

return SoundController
