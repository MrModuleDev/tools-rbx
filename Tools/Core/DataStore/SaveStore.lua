local Event = require(script.Parent.Parent.Parent:WaitForChild("Core"):WaitForChild("Event"))

local Tools = require(game.ReplicatedStorage.Tools)
local Extends = require(script.Parent)
export type type = {
	autoSave : Event.type,
	autoSaveFrequency : number,
	sessionLockLimit : number,
	
	close : (self : {}, key : string, value : any) -> (boolean, any),
	open : (self : {}, key : string) -> (boolean, any),
	save : (self : {}, key : string, value : any) -> (boolean, any)
} & Extends.type
export type class = {new : (dataStoreName : string) -> type} & Extends.class
local Class : class, super : Extends.type = Tools.class(script.Name, Extends, Tools.enum.pattern.class)

type saveStoreReturnType = {
	data : {}?,
	session : number?,
	sessionLock : number?
}

function Class.SaveStore(self : type, dataStoreName : string)
	super(self, dataStoreName)
	self.autoSave = Event.new()
	self.autoSaveFrequency = 60
	self.sessionLockLimit = 120
	
	task.spawn(function()
		while task.wait(self.autoSaveFrequency) do
			self.autoSave:fire()
		end
	end)
end

function Class.close(self : type, key : string, data : any)
	local unlocked = true
	local closeResult = ""
	local success, result = self:update(key, function(old : saveStoreReturnType?)
		if (not old) or (not old.session) or (not old.sessionLock) or (old.session == game.JobId) or (os.time() - old.sessionLock) >= self.sessionLockLimit then
			old.data = data
			old.session = nil
			old.sessionLock = nil
		else
			unlocked = false
			closeResult = "Session is locked | " .. (os.time() - old.sessionLock)
		end
		return old
	end)

	local closeSuccess = success and unlocked
	closeResult = (not success or closeSuccess) and result or closeResult
	return closeSuccess, closeResult
end

function Class.open(self : type, key : string)
	local unlocked = true
	local loadResult = ""
	local success, result = self:update(key, function(old : saveStoreReturnType?)
		if not old then
			old = {}
			old.sessionLock = os.time()
			old.session = game.JobId
		elseif not old.sessionLock or (old.sessionLock and (os.time() - old.sessionLock) >= self.sessionLockLimit) then
			old.sessionLock = os.time()
			old.session = game.JobId
		else
			unlocked = false
			loadResult = "Session is locked | " .. (os.time() - old.sessionLock)
		end

		return old
	end)

	local loadSuccess = success and unlocked
	loadResult = (not success or loadSuccess) and result or loadResult
	return loadSuccess, (loadSuccess and loadResult.data or loadResult)
end

function Class.save(self : type, key, data)
	local unlocked = true
	local saveResult = ""
	local success, result = self:update(key, function(old : saveStoreReturnType?)
		if (not old) or (not old.session) or (not old.sessionLock) or (old.session == game.JobId) or (os.time() - old.sessionLock) >= self.sessionLockLimit then
			old.data = data
			old.session = game.JobId
			old.sessionLock = os.time()
		else
			unlocked = false
			saveResult = "Session is locked | " .. (os.time() - old.sessionLock)
		end
		return old
	end)

	local saveSuccess = success and unlocked
	saveResult = (not success or saveSuccess) and result or saveResult
	return saveSuccess, saveResult
end

return Class
