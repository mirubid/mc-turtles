if(nil==nav) then os.loadAPI("nav") end
if(nil==util ) then os.loadAPI("util") end
if(nil==inventory) then os.loadAPI("inventory") end
if(nil==events) then os.loadAPI("events") end
if(nil==deque) then os.loadAPI("deque") end
local function begin(self,dir)
	
end
function new(itemsToMine)
	local events=events.new()
	local initial={}
	local visitedRoom = deque.new()
	local cells={}
	
	local function begin()
		initial.pos = nav.getPos()
		initial.bearing = nav.getBearing()
		
		initial.cell = getCell(initial.pos)
		initial.cell.visited=true
		
	end
	local function getCell(pos)
		-- returns cell, isNew
		local key = pos:toString()
		local cell = cells[key]
		if(nil ~= cell) then
			return cell, false
		end
		cell = createCell(pos)
		cells[key]=cell, true
	end
end
local Cell={
	key=function(self)
		return self.pos:toString()
	end
}
local function createCell(pos)
	if(nil==pos) then pos=nav.getPos() end
	local cell = {
		pos=pos,
		visited=false,
		
	}
	return setmetatable(cell, {__index = Cell})
end