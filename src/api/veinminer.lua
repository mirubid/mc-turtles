if(nil==nav) then os.loadAPI("nav") end
if(nil==util ) then os.loadAPI("util") end
if(nil==inventory) then os.loadAPI("inventory") end
if(nil==events) then os.loadAPI("events") end
--if(nil==deque) then os.loadAPI("deque") end
print("loading veinminer")
local function createCell(pos)
	if(nil==pos) then pos=nav.getPos() end
	local cell = {
		pos=pos,
		visited=false,
		
	}
	return cell
end
function new(itemsToMine)
	--local events=events.new()
	local initial={}
	--local cellStack = deque.new()
	local cells={}
	local count=0

	local function getCell(pos)
		-- returns cell, isNew
		local key = pos:tostring()
		local cell = cells[key]
		if(nil ~= cell) then
			return cell, false
		end
		cell = createCell(pos)
		cells[key]=cell
		return cell, true
	end

	local function dig(targetPos)
		
		local status,reason,dir = nav.face(targetPos)
		if(dir==nil) then dir="" end
		if(not status and reason~="vertical")then
			print("couldn't face "..targetPos:tostring().." "..reason)
			return false, reason
		end
		
		if (util.inspectedMatchesAny(itemsToMine,dir)) then
			return turtle["dig"..dir]()
		else
			return false, "nothing there"
		end
	end
	
	local function cellsToVisit(cell,predicate)
	
		-- create an `array` of all the cells adjection to cell
		--    which are not visited yet and satiisfy predicate
		local locs= {}
		local next_cells={}
		local b
		for b=0,3 do
			local dir = nav.bearingToVector(b)
			table.insert(locs, cell.pos + dir)
		end
		table.insert(locs, cell.pos + nav.vectors.up)
		table.insert(locs, cell.pos + nav.vectors.down)
		local _, pos
		for _,pos in pairs(locs) do
			local adj_cell,isnew = getCell(pos)
			if(isnew==true and adj_cell.visited==false and predicate(pos) ) then
				table.insert(next_cells,adj_cell)
			end
		end
		return next_cells
	end
	function report()
		print ("vein mining for")
		local _, v
		for _,v in pairs(itemsToMine) do print(v) end
		
	end
	local function visit(cell)
		if(cell.visited) then return end
		local start_pos = nav.getPos()
		
		--print("visit: "..start_pos:tostring().."-->"..cell.pos:tostring())
		assert(nav.moveTo(cell.pos))
		local current_pos = nav.getPos()
		assert(current_pos:tostring()==cell.pos:tostring(),"expected "..current_pos:tostring().."=="..cell.pos:tostring())
		count = count + 1
		--cellStack:push_right(cell)
		cell.visited=true
		local next_cells = cellsToVisit(cell,dig)
		
		local next_cell, _
		--term.write(" ->")
		--for _,next_cell in pairs(next_cells) do term.write(next_cell.pos:tostring().."|") end
		--print("")
		for _,next_cell in pairs(next_cells) do
			visit(next_cell)
		end
		--cellStack:pop_right(cell)
		-- return to previous location
		--print("leaving cell "..cell.pos:tostring())
		nav.moveTo(start_pos)
	end
	local function begin()
		print("vm starting")
		cells={}
		initial.pos = nav.getPos()
		initial.bearing = nav.getBearing()	
		print("initial position: "..initial.pos:tostring())
		print("        bearing: "..initial.bearing)
		
		initial.cell = getCell(initial.pos)
		count=0
		visit(initial.cell)
		nav.faceBearing(initial.bearing)
		print("done. cells visited: "..count)
	end
	return {begin=begin,report=report}
end

