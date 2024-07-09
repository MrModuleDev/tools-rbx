local DataStoreService = game:GetService("DataStoreService")

local Tools = require(game.ReplicatedStorage.Tools)
local Extends = require(script.Parent:WaitForChild("BaseClass"))
export type type = {
	dataStoreName : string,
	dataStore : DataStore,
	
	get : (self : {}, key : string) -> (boolean, any),
	set : (self : {}, key : string, value : any) -> (boolean, any),
	update : (self : {}, key : string, func : (any) -> any) -> (boolean, any)
} & Extends.type
export type class = {new : (dataStoreName : string) -> type} & Extends.class
local Class : class, super = Tools.class(script.Name, Extends, Tools.enum.pattern.class)

function Class.DataStore(self : type, dataStoreName : string)
	super(self)
	self.dataStoreName = dataStoreName
	self.dataStore = DataStoreService:GetDataStore(dataStoreName)
end

function Class.get(self : type, key : string)
	return pcall(function()
		return self.dataStore:GetAsync(key)
	end)
end

function Class.set(self : type, key : string, value : any)
	return pcall(function()
		return self.dataStore:SetAsync(key)
	end)
end

function Class.update(self : type, key : string, func)
	return pcall(function()
		return self.dataStore:UpdateAsync(key, func)
	end)
end

return Class
