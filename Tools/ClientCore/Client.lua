local Players = game:GetService("Players")

local Tools = require(game.ReplicatedStorage.Tools)
local Extends = require(script.Parent.Parent:WaitForChild("Core"):WaitForChild("BaseClass"))
export type type = {
	character : Model?,
	
	loadAnimation : (self : {}, animation : Animation) -> AnimationTrack,
	onDeath : (self : {}) -> nil,
	onDespawn : (self : {}, character : Model) -> nil,
	onSpawn : (self : {}, character : Model) -> nil,
	onSpawnStepped : (self : {}, character : Model) -> nil
} & Extends.type
export type class = {new : (screen : ScreenGui) -> type} & Extends.class
local Class : class, super = Tools.class(script.Name, Extends, Tools.enum.pattern.abstract)

local player = Players.LocalPlayer

function Class.Client(self : type, screenGui : ScreenGui)
	super(self)
	
	self:bind(player.CharacterAdded, "getCharacter", function(self : type, character)
		self.character = character
		local humanoid : Humanoid = character:WaitForChild("Humanoid")
		self:bindOnce(humanoid.Died, "onDeath")
	end)
	self:bind(player.CharacterRemoving, "onDespawn")
	self:bind(player.CharacterAdded, "onSpawn")
end

Class.onDeath = Tools.abstract
Class.onDespawn = Tools.abstract
Class.onSpawn = Tools.abstract
Class.onSpawnStepped = Tools.abstract

function Class.loadAnimation(self : type, animation : Animation)
	local character = self.character or player.CharacterAdded:Wait()
	local humanoid : Humanoid = character:WaitForChild("Humanoid")
	local animator : Animator = humanoid:WaitForChild("Animator")
	local track = animator:LoadAnimation(animation)
	return track
end

return Class
