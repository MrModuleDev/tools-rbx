local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Tools = require(script:FindFirstAncestor("Tools")) 
local Extends = require(script.Parent)
export type type = {
	pitch : Attachment,
	pivot : Attachment,
	root : Part,
	head : Part,
	xDelta : number,
	yDelta : number,
	targetLook : Vector3,
	tilt : number
} & Extends.type
export type class = {new : (camera : Camera?) -> type} & Extends.class
local Class : class, super : Extends.type = Tools.class(script.Name, Extends)

local player = game.Players.LocalPlayer

function Class.FirstPerson(self : type, camera : Camera?)
	super(self, camera or Instance.new("Camera"))
	self.character = {}
	self.character.arms = {"RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperArm", "LeftLowerArm", "LeftHand"}
	self.character.legs = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot"}
	self.character.body = {"UpperTorso", "LowerTorso", "HumanoidRootPart"}
	self:setCameraType(Enum.CameraType.Scriptable)
	self:setMouseBehavior(Enum.MouseBehavior.LockCenter)
	self.camera.FieldOfView = 85
	self:bind(player.CharacterAdded, "characterAdded", self.onCharacterAdded)
	if player.Character then self:onCharacterAdded(player.Character) end
end

function Class.onCharacterAdded(self : type, character : Model)
	self.root = character:WaitForChild("HumanoidRootPart")
	self.head = character:WaitForChild("Head")
	self.pivot = Instance.new("Attachment")
	self.pivot.Parent = self.root
	self.pivot.Position = Vector3.new(0,1.25,-.75)
	self.xDelta = 0
	self.yDelta = 0
	self.tilt = 0
	local torso : Part = character:WaitForChild("UpperTorso")
	local lowtorso : Part = character:WaitForChild("LowerTorso")
	for l, legPartName : string in pairs(self.character.legs) do
		character:WaitForChild(legPartName).Transparency = 1
	end
	for l, armPartName : string in pairs(self.character.legs) do
		character:WaitForChild(armPartName).CastShadow = false
	end
	self.head:WaitForChild("face").Transparency = 1
	local children = character:GetDescendants()
	for c, child in ipairs(children) do
		if child:IsA("Accessory") and not child:GetAttribute("FirstPersonVisible") then child:Destroy() end
	end
	local lowtorso : Part = character:WaitForChild("LowerTorso")
	self.head.Transparency = 1
	torso.Transparency = 1
	lowtorso.Transparency = 1
end

function Class.calculateTile(self : type, x, y, delta)
	self.tilt = math.clamp(self.tilt + (x/8), -50, 50) * .9
	self.tilt = math.abs(self.tilt) < .1 and 0 or self.tilt
end

function Class.calculateDeltas(self : type, x, y)
	self.xDelta += (x / 14) * 5
	self.yDelta += (y / 10) * 5
	if self.xDelta >= 360 then self.xDelta -= 360 elseif self.xDelta < 0 then self.xDelta += 360 end
	if self.yDelta > 75 then self.yDelta = 75 elseif self.yDelta < -75 then self.yDelta = -75 end
end

function Class.onStep(self : type, deltaT : number)
	super.onStep(self, deltaT)
	if self.pivot and self.root then
		local delta = workspace.CurrentCamera == self.camera and UserInputService:GetMouseDelta() or Vector2.zero
		local x, y = -delta.X, -delta.Y
		self:calculateTile(x, y, deltaT)
		self:calculateDeltas(x, y)
		local lookFrame = CFrame.new(Vector3.new(0,0,0))
		lookFrame *= CFrame.Angles(0, math.rad(self.xDelta), 0)
		lookFrame *= CFrame.Angles(math.rad(self.yDelta), 0, 0)
		self.targetLook = lookFrame.LookVector
		self.pivot.CFrame = CFrame.lookAt(self.pivot.CFrame.Position, self.pivot.CFrame.Position + self.pivot.CFrame.LookVector) 
		local xzLook = self.pivot.CFrame.LookVector
		xzLook = Vector3.new(xzLook.X, 0, xzLook.Z)
		self.root.CFrame = CFrame.lookAt(self.root.CFrame.Position, self.root.CFrame.Position + xzLook)	
		local targetPos = self.pivot.CFrame.Position
		local target = CFrame.lookAt(targetPos, targetPos + self.targetLook)
		TweenService:Create(self.pivot, TweenInfo.new(.25, Enum.EasingStyle.Quart), {CFrame = target}):Play()
		local cameraCFrame = CFrame.lookAt(self.pivot.WorldCFrame.Position, self.pivot.WorldCFrame.Position + self.pivot.CFrame.LookVector, self.pivot.CFrame.UpVector)
		cameraCFrame *= CFrame.Angles(0, 0, math.rad(self.tilt / 6))
		self.camera.CFrame = cameraCFrame
	end
end

return Class