local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Tools = require(game.ReplicatedStorage.Tools)
local Extends = require(script.Parent)
export type type = {
	target : BasePart,
	subject : Part,
	loaded : boolean
} & Extends.type
export type class = {new : () -> type} & Extends.class
local Class : class, super : Extends.type = Tools.class(script.Name, Extends, Tools.enum.pattern.class)

function Class.SmoothThirdPerson(self : type, camera : Camera?)
	super(self, camera or Instance.new("Camera"))
	self.subject = Instance.new("Part")
	self.subject.CanCollide = false
	self.subject.Size = Vector3.new(1,1,1)
	self.subject.Transparency = 1
	self.subject.Anchored = true
	self.camera.CameraSubject = self.subject
	self.loaded = false
	self:setCameraType(Enum.CameraType.Custom)
end

function Class.onStep(self : type, delta : number)
	super.onStep(self, delta)
	local character = player.Character
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart") or nil
	if self.target ~= root then
		self.loaded = false
	end
	self.target = root
	if self.target then
		if not self.loaded then
			self.loaded = true
			self.subject.CFrame = self.target.CFrame
		end
		self.subject.Parent = workspace
		self.camera.CameraSubject = self.subject
		TweenService:Create(self.subject, TweenInfo.new(.085), {CFrame = self.target.CFrame + Vector3.new(0,1,0)}):Play()
	end
end

return Class
