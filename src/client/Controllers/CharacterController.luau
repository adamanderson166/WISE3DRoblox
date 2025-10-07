-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- References
local Player: Player = Players.LocalPlayer

-- Variables
local PlayerModule

--
local CharacterController = {}

function CharacterController:StopAnimation()
	if self.Animation then
		self.Animation:Stop()
		self.Animation:Destroy()
		self.Animation = nil
	end
end

function CharacterController:PlayAnimation(animId: string, fadeValue: number, weight: number, speed: number)
	self:StopAnimation()

	local character: Model = Player.Character or Player.CharacterAdded:Wait()
	local humanoid: Humanoid = character.Humanoid

	local animation: Animation = Instance.new("Animation")
	animation.AnimationId = animId

	self.Animation = humanoid.Animator:LoadAnimation(animation)
	self.Animation:Play(fadeValue, weight, speed)
end

function CharacterController:SetHumanoidState(humanoidState: Enum.HumanoidStateType)
	local character: Model = Player.Character or Player.CharacterAdded:Wait()
	local humanoid: Humanoid = character:FindFirstChild("Humanoid")

	if humanoid then
		humanoid:ChangeState(humanoidState)
	end
end

function CharacterController:MoveToLocation(location: Vector3 | CFrame)
	local character: Model = Player.Character or Player.CharacterAdded:Wait()
	character:PivotTo(typeof(location) == "CFrame" and location or CFrame.new(location))
end

function CharacterController:Jump()
	local character: Model = Player.Character or Player.CharacterAdded:Wait()
	local humanoid: Humanoid = character.Humanoid

	if humanoid then
		humanoid.Jump = true
	end
end

function CharacterController:ToggleControls(toggle: boolean)
	if toggle then
		PlayerModule:Enable()
	else
		PlayerModule:Disable()
	end
end

function CharacterController:OnStart()
	PlayerModule = require(Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
end

return CharacterController
