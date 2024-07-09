local Tools = require(game.ReplicatedStorage.Tools)
local Extends = require(script.Parent:WaitForChild("BaseClass"))
export type type = {
	bindableEvent : BindableEvent,
	signal: RBXScriptSignal	,
	
	connect : (self : {}, func : (any) -> any) -> RBXScriptConnection,
	fire : (self : {}, ...any) -> nil,
} & Extends.type
export type class = {new : () -> type} & Extends.class
local Class : class, super = Tools.class(script.Name, Extends)

function Class.Event(self : type)
	super(self)
	self.bindableEvent = Instance.new("BindableEvent")
	self.signal = self.bindableEvent.Event
end

function Class.connect(self : type, func)
	return self.signal:Connect(func)
end

function Class.destroy(self : type)
	super.destroy(self)
	self.bindableEvent:Destroy()
	self.bindableEvent = nil
	self.signal = nil
end

function Class.fire(self : type, ...)
	self.bindableEvent:Fire(...)
end

return Class
