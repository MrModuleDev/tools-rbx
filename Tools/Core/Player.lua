local RunService = game:GetService("RunService")

local Tools = require(game.ReplicatedStorage.Tools)
local Extends = require(script.Parent:WaitForChild("BaseClass"))
export type type = {
	character : Model?,
	player : Player,
	
	onDeath : (self : {}) -> nil,
	onSpawn : (self : {}, character : Model) -> nil,
	onSpawnStepped : (self : {}, character : Model) -> nil,
	spawn : (self : {}, description : HumanoidDescription?) -> nil
} & Extends.type
export type class = {new : (player : Player) -> type} & Extends.class
local Class : class, super = Tools.class(script.Name, Extends, Tools.enum.pattern.abstract)

function Class.Player(self : type, player : Player)
	super(self)
	self.character = nil
	self.player = player
	
	self:bind(player.CharacterRemoving, "onDespawn")
	self:bind(player.CharacterAdded, "onSpawn")
	self:bind(player.CharacterAdded, "onSpawnStepped", function(...)
		RunService.Heartbeat:Wait()
		return self.onSpawnStepped(...)
	end)
	self:bind(player.CharacterAdded, "getCharacter", function(self : type, character)
		self.character = character
		local humanoid : Humanoid = character:WaitForChild("Humanoid")
		self:bindOnce(humanoid.Died, "onDeath")
	end)
end

Class.onDeath = Tools.abstract
Class.onDespawn = Tools.abstract
Class.onSpawn = Tools.abstract
Class.onSpawnStepped = Tools.abstract

function Class.spawn(self : type, description : HumanoidDescription?)
	if not description then
		self.player:LoadCharacter()
	else
		self.player:LoadCharacterWithHumanoidDescription(description)
	end
end

return Class
