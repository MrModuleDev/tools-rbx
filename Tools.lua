local Tools = {}
Tools.enum = {
	pattern = {
		class = "__class",
		singleton = "__singleton",
		multiton = "__multiton",
		abstract = "__abstract"
	},
	error = {
		[404] = "[TOOLS ERROR 404]: Could not find constructor in class: ",
		[501] = "[TOOLS ERROR 501]: Abstract class must be extended from non-abstract class | Class: ",
		[502] = "[TOOLS ERROR 502]: Abstract function must be overrided by extended class | Class: "
	}
}

Tools.abstract = function(object)
	return error(Tools.enum.error[502] .. ( object and object.__name or "???"))
end

Tools.pass = function()
	return
end

type toolType = {
	enum : typeof(Tools.enum),
	class : (name : string, super : {}, pattern : string) -> {},
	abstract : (object : {}) -> nil,
	pass : () -> nil
}

function Tools.__index(class, key)
	return class.__extends and class.__super[key] or nil
end

function Tools.__abstract(class, ...)
	return error(Tools.enum.error[501] .. class.__name)
end

function Tools.__class(class, ...)
	local object = {}
	local constructor = class[class.__name]
	setmetatable(object, class)
	return constructor and (constructor(object, ...) or true) and object or error(Tools.enum.error[404] .. class.__name)
end

function Tools.__singleton(class)
	class.__singleton = class.__singleton or Tools.__class(class)
	return class.__singleton
end

function Tools.__multiton(class, key)
	class.__multiton = class.__multiton or {}
	class.__multiton[key] = class.__multiton[key] or Tools.__class(class, key)
	return class.__multiton[key]
end

function Tools.__call(class, ...)
	return Tools[(class.__pattern or "__class")](class, ...)
end

function Tools.class(name, super, pattern)
	local class = {}
	class.__name = name
	class.__super = super
	class.__index = class
	class.__pattern = pattern
	class.__extends = (super and true) or false
	class.new = function(...)
		return Tools.__call(class, ...)
	end
	
	if class.__extends then
		class.super = {}
		local meta = {}
		meta.__call = function(self, ...)
			class.__super[class.__super.__name](...)
		end
		meta.__index = class.__super
		meta.__newindex = class.__super
		setmetatable(class.super, meta)
	end
	
	setmetatable(class, Tools)
	
	return class, class.__extends and class.super or nil
end

local typedTools : toolType = Tools
return typedTools
