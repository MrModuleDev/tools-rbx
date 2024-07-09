local Tools = require(script:FindFirstAncestor("Tools"))
export type type = {	
	connections : {RBXScriptConnection},
	
	bind : (self : {}, event : RBXScriptSignal, key : string, func : (any) -> any) -> RBXScriptConnection,
	bindOnce : (self : {}, event : RBXScriptSignal, key : string, func : (any) -> any) -> RBXScriptConnection,
	destroy : (self : {}) -> nil,
	unbind : (self : {}, key : string) -> nil
} & Super.type
export type class = {new : () -> type}
local Class : class = Tools.class(script.Name)

function Class.BaseClass(self : type)
	self.connections = {}
end

function Class.bind(self : type, event : RBXScriptSignal, key, func)
	func = func or self[key]
	local connection : RBXScriptConnection = event:Connect(function(...)
		return func(self, ...)
	end)
	self.connections[key] = connection
	return connection
end

function Class.bindOnce(self : type, event : RBXScriptSignal, key, func)
	func = func or self[key]
	local connection : RBXScriptConnection = event:Once(function(...)
		self:unbind(key)
		return func(self, ...)
	end)
	self.connections[key] = connection
	return connection
end

function Class.destroy(self : type)
	for i, connection : RBXScriptConnection in pairs(self.connections) do
		connection:Disconnect()
	end
	table.clear(self.connections)
end

function Class.unbind(self : type, key)
	local connection : RBXScriptConnection = self.connections[key]
	self.connections[key] = connection and connection:Disconnect() or nil
end

return Class
