-- event mechanism
if(events) then
	print("events already loaded")
end
local Event={}
local function on(self, eventName, callback)
	if(nil==self.events[eventName])then
		self.events[eventName]={}
	end
	if(self.events[eventName][callback]) then
		return
	end
	self.events[eventName][callback]=true
end
local function off(self,eventName,callback)
	if(nil==self.events or nil==self.events[eventName]) then return end
	self.events[eventName]=nil
end
local function trigger(self,eventName,...)
	if(nil==self.events or nil==self.events[eventName]) then return end
	for callback,v in pairs(self.events[eventName]) do
		callback(...)
	end
end
local methods={
	on=on,
	off=off,
	trigger=trigger
}
function new()
	local r = {events={}} 
	return setmetatable(r, {__index = methods}) 

end