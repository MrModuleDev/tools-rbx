local Tools = require(script:FindFirstAncestor("Tools")) 
local Extends = require(script.Parent.Parent:WaitForChild("Core"):WaitForChild("BaseClass"))
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local playerModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
local controls = playerModule:GetControls()

export type type = {
	camera : Camera,
	cameraType : Enum.CameraType,
	mouseBehavior : Enum.MouseBehavior,
	mouseVisible : boolean,
	playerControllerEnabled : boolean,
	
	onCameraTypeChanged : (self : {}) -> nil,
	setCameraType : (self : {}, cameraType : Enum.CameraType) -> nil,
	setMouseBehavior : (self : type, mouseBehavior : Enum.MouseBehavior) -> nil
} & Extends.type
export type class = {new : () -> type} & Extends.class
local Class : class, super = Tools.class(script.Name, Extends)

function Class.Camera(self : type, camera : Camera?)
	super(self)
	self.playerControllerEnabled = true
	self.mouseBehavior = Enum.MouseBehavior.Default
	UserInputService.MouseBehavior = self.mouseBehavior
	self.mouseVisible = true
	self.camera = camera or Instance.new("Camera")
	self.camera.Parent = workspace
	self.cameraType = self.camera.CameraType
	local cameraTypeChangedEvent = self.camera:GetPropertyChangedSignal("CameraType")
	self:bind(cameraTypeChangedEvent, "cameraTypeChanged", self.onCameraTypeChanged)
	self:bind(RunService.RenderStepped, "onRender", self.onStep)
end

function Class.onStep(self : type, delta : number)
	if workspace.CurrentCamera == self.camera then
		UserInputService.MouseIconEnabled = self.mouseVisible
		if self.playerControllerEnabled then
			controls:Enable()
		else
			controls:Disable()
		end
	end
end

function Class.onCameraTypeChanged(self : type)
	local newType = self.camera.CameraType
	if newType ~= self.cameraType then
		self.camera.CameraType = self.cameraType
	end
end

function Class.setCameraType(self : type, cameraType : Enum.CameraType)
	self.cameraType = cameraType
	self.camera.CameraType = self.cameraType	
end

function Class.setMouseBehavior(self : type, mouseBehavior : Enum.MouseBehavior)
	self.mouseBehavior = mouseBehavior
	UserInputService.MouseBehavior = self.mouseBehavior
end

return Class
