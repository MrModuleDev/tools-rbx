local Players = game:GetService("Players")

local Tools = require(game.ReplicatedStorage.Tools)
local Extends = require(script.Parent.Parent:WaitForChild("Core"):WaitForChild("BaseClass"))
export type type = {
	base : ScreenGui,
	gui : ScreenGui,
	resetOnDespawn : boolean,
	removeOnDespawn : boolean,
	
	hide : (self : {}) -> nil,
	onCharacterRemoving : (self : {}, character : Model) -> nil,
	show : (self : {}) -> nil,
	toggle : (self : {}) -> nil
} & Extends.type
export type class = {new : (screen : ScreenGui) -> type} & Extends.class
local Class : class, super = Tools.class(script.Name, Extends)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function Class.Screen(self : type, screenGui : ScreenGui)
	super(self)
	self.base = screenGui
	self.gui = screenGui:Clone()
	self.gui.Parent = playerGui
	self.gui.ResetOnSpawn = false
	self.removeOnDespawn = false
	self.resetOnDespawn = true
	self:bind(player.CharacterRemoving, "onCharacterRemoving")
end

function Class.onCharacterRemoving(self : type, character : Model)
	if self.removeOnDespawn then
		self.gui:Destroy()
	elseif self.resetOnDespawn then
		self.gui:Destroy()
		self.gui = self.base:Clone()
		self.gui.Parent = playerGui
	end
end

function Class.hide(self : type)
	self.gui.Enabled = false
end

function Class.show(self : type)
	self.gui.Enabled = true
end

function Class.toggle(self : type)
	return self.gui.Enabled and (self:hide() or true) or self:show()
end

function Class.destroy(self : type)
	super.destroy(self)
	self.gui:Destroy()
	self.gui = nil
	self.base = nil
end

return Class
