-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- References
local Player: Player = Players.LocalPlayer

-- Variables
local PlayerModule

--
local CharacterController = {}

function CharacterController:PlayAnimation(animId: string)
	if self._animation then
		self._animation:Stop()
		self._animation:Destroy()
		self._animation = nil
	end

	local character: Model = Player.Character or Player.CharacterAdded:Wait()
	local humanoid: Humanoid = character.Humanoid

	local animation: Animation = Instance.new("Animation")
	animation.AnimationId = animId

	self._animation = humanoid.Animator:LoadAnimation(animation)
	self._animation:Play(0, 1, 1.5)
end

function CharacterController:MoveToLocation(location: Vector3 | CFrame)
	local character: Model = Player.Character or Player.CharacterAdded:Wait()
	character:PivotTo(typeof(location) == "CFrame" and location or CFrame.new(location))
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
