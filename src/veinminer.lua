if(nil==nav) then os.loadAPI("nav") end
if(nil==util ) then os.loadAPI("util") end
if(nil==inventory) then os.loadAPI("inventory") end
if(nil==events) then os.loadAPI("events") end
if(nil==deque) then os.loadAPI("deque") end

function new(itemsToMine)
	local events=events.new()
	local initial={}
	local cellStack = deque.new()
	local cells={}
	
	local function begin(dirV)
		initial.pos = nav.getPos()
		initial.bearing = nav.getBearing()
		
		initial.cell = getCell(initial.pos)
		
		visit(initial.cell)
		
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
	local function visit(cell)
		local pos = nav.getPos()
		
		assert(nav.moveTo(cell.pos))
		--cellStack:push_right(cell)
		cell.visited=true
		local cells = cellsToVisit(cell,dig)
		for next_cell,_ in cells do
			visit(next_cell)
		end
		--cellStack:pop_right(cell)
		-- return to previous location
		nav.moveTo(pos)
	end
	local function dig(targetCell)
		local status,reason,dir = nav.face(targetCell.pos)
		if(not status and reason~="vertical")then
			return false, reason
		end
		
		if (util.inspectedIsAny(itemsToMine,dir)) then
			return turtle.dig()
		else
			return false, "nothing there"
		end
	end
	local function cellsToVisit(cell,predicate)
		local locs= {}
		local cells={}
		for b=0,3 do
			local dir = nav.bearingToVector(b)
			table.insert(locs, cell.pos + dir)
		end
		table.insert(locs, cell.pos + nav.vectors.up)
		table.insert(locs, cell.pos + nav.vectors.down)
		for pos,_ in pairs(locs) do
			local adj_cell = getCell(pos)
			if(adj_cell.visited==false and predicate(pos) ) then
				table.insert(cells,adj_cell)
			end
		end
		return cells
	end
end

local function createCell(pos)
	if(nil==pos) then pos=nav.getPos() end
	local cell = {
		pos=pos,
		visited=false,
		
	}
	return cell
end