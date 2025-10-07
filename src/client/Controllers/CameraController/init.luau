-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")

-- References
local LocalPlayer = PlayerService.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables
local InputController

--
local CameraController = {}

function CameraController:ClearCameraUpdateConnection()
	if self.CameraConnection then
		self.CameraConnection:Disconnect()
		self.CameraConnection = nil
	end
end

function CameraController:SetCameraType(cameraType: Enum.CameraType)
	self:ClearCameraUpdateConnection()
	Camera.CameraType = cameraType
end

function CameraController:SetCameraSubject(subject: Instance)
	self:SetCameraType(Enum.CameraType.Custom)
	Camera.CameraSubject = subject
end

function CameraController:SetOrbitalCameraAroundObject(target: BasePart, distanceOffset: number, heightOffset: number)
	self:SetCameraType(Enum.CameraType.Scriptable)

	local xRotation: number = math.pi / 2
	local yRotation: number = 0
	local lastDelta: number = Vector2.zero

	local function updateCamera()
		local delta: Vector2 = InputController:GetInputDelta()

		xRotation = xRotation - delta.X
		yRotation = math.clamp(yRotation + delta.Y, -math.pi / 3, math.pi / 3)

		local targetPosition: Vector3 = target.Position + Vector3.new(0, heightOffset, 0)

		local rotation: CFrame = CFrame.Angles(0, xRotation, 0) * CFrame.Angles(yRotation, 0, 0)
		local offset: Vector3 = rotation * Vector3.new(0, 0, -distanceOffset)

		Camera.CFrame = CFrame.lookAt(targetPosition + offset, targetPosition)
	end

	updateCamera()

	self.CameraConnection = RunService.RenderStepped:Connect(function(deltaTime)
		local delta: Vector2 = InputController:GetInputDelta()

		if delta == lastDelta then
			return
		end

		updateCamera()

		lastDelta = delta
	end)
end

function CameraController:FollowTargetWithOffset(
	target: BasePart,
	targetDirection: Vector3,
	cameraFollowOffset: Vector3,
	lerp: boolean?
)
	self:SetCameraType(Enum.CameraType.Scriptable)

	local function updateCamera()
		local targetPosition: Vector3 = target.Position

		local cameraPosition = targetPosition
			- (targetDirection * cameraFollowOffset.Z)
			+ Vector3.new(0, cameraFollowOffset.Y, 0)

		local targetCFramame: CFrame = CFrame.new(cameraPosition, targetPosition)

		if lerp then
			Camera.CFrame = Camera.CFrame:Lerp(targetCFramame, 0.3)
		else
			Camera.CFrame = targetCFramame
		end
	end

	self.CameraConnection = RunService.RenderStepped:Connect(function()
		updateCamera()
	end)
end

function CameraController:CircleAroundTarget(
	target: BasePart,
	startingAngle: number,
	radius: number,
	speed: number,
	yOffset: number
)
	self:SetCameraType(Enum.CameraType.Scriptable)

	local angle: number = startingAngle
	local targetPosition: Vector3 = target.Position

	local function updateCamera(deltaTime: number)
		angle = angle + speed * deltaTime

		local x: number = math.cos(angle) * radius
		local z: number = math.sin(angle) * radius

		local newPos = targetPosition + Vector3.new(x, yOffset, z)
		Camera.CFrame = CFrame.new(newPos, targetPosition)
	end

	self.CameraConnection = RunService.RenderStepped:Connect(function(deltaTime: number)
		updateCamera(deltaTime)
	end)
end

function CameraController:FocusCameraOnPlayer()
	local character: Model = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	self:SetCameraSubject(character:FindFirstChild("Humanoid"))
end

function CameraController:OnStart()
	InputController = require(ReplicatedStorage.Client.Controllers.InputController)
end

return CameraController
