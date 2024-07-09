local Players = game:GetService("Players")

local Tools = require(game.ReplicatedStorage.Tools)
local Extends = require(script.Parent:WaitForChild("BaseClass"))
export type type = {
	onJoin : (self : {}, player : Player) -> nil,
	onLeave : (self : {}, player : Player) -> nil
} & Extends.type
export type class = {new : () -> type} & Extends.class
local Class : class, super = Tools.class(script.Name, Extends, Tools.enum.pattern.abstract)

function Class.Server(self : type)
	super(self)
	
	self:bind(Players.PlayerAdded, "onJoin")
	self:bind(Players.PlayerRemoving, "onLeave")
end

Class.onJoin = Tools.abstract
Class.onLeave = Tools.abstract

return Class
