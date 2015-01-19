-- pave
if(nil==deque) then os.loadAPI("api/deque") end

local x,y
local start_pos=nav.getPos()
local start_bearing=nav.getBearing()
local going=false

function parseArgs(targs)
	local dimensions = deque.new()
	local shape
	if(#targs == 0) then
		shape="rectangle"
		dimensions:push_right(8)
		dimensions:push_right(8)
	end
	local i,v
	for i,v in pairs(targs) do
		local n = tonumber(v)
		if(n) then 
			dimensions:push_right(n) 	
		else
			shape = v
		end
	end
	if(not shape) then
		shape="rectangle"
	end
	return shape, dimensions
end

local function pave_down()
	turtle.placeDown()
end
local function rect_iter(dimensions,f)
	local z,x= dimensions[1], dimensions[2]
	local x_bearing = (start_bearing + 1) % 4
	if ( not z or not x) then
		print("two dimensions required")
		return nil
	end
	
	z = math.abs(z)
	print(z.."x"..x.." rectangle")
	
	if(x<0) then
		x_bearing=-1
	end
	local i,j,di,dj = 0,1,1,1
	local function iter_z()
		term.write("z:")
		term.write(" "..i..","..j.."("..di..")")
		local bearing = start_bearing
		
		if(di < 0) then
			bearing = (start_bearing + 2) % 4
		end
		
		i = i + di
		if(i>z or i<1) then
			-- out of bounds: don't go there
			term.write(" z:out of bounds")
			i=i-di
			di = di * -1
			return nil
		end
		if( nav.moveDir(bearing) ) then
			f()		
			return true
		end
		return nil
	end
	
	local function iter_x()
		term.write("x:")
		j = j + dj
		term.write(" "..i..","..j.."("..dj..")"..x_bearing)
		if (j>math.abs(x) ) then
			term.write(" out of bounds")
			return nil
		end
		term.write(" bearing"..x_bearing)
		if(nav.moveDir(x_bearing)) then
			f()
			return true
		end
		return nil
	end
	return function()
		if ( (iter_z() or iter_x()) ) then
			return true
		else
			return nil
		end
	end
end

local function wall_iter(dimensions,f)
	return nil
end
local function paver()
	local slot=1
	function selectItem()
		while (turtle.getItemCount(slot)==0 and slot < 17) do
			slot=slot+1
		end
		if(turtle.getItemCount(slot)==0) then
			return false,"turtle needs something to pave with"
		end
		return true
	end
	
	return function() 
		if(selectItem()) then
			turtle.select(slot)
			turtle.placeDown()
			return true
		else
			return false
		end
		--term.write(" paved")
		--os.sleep(1) 
	end
end
shapes={
	rectangle=rect_iter
}
function go(shape,dimensions,f)
	if(goig) then
		return false, "paver already going"
	end
	start_pos=nav.getPos()
	start_bearing=nav.getBearing()
	going=true
	local _
	print ( "paving a "..shape)
	for _ in shapes[shape]( dimensions, f ) do print("") end
	print("done")
	going = false
end
function pave(shape,dimensions)
	go( shape,dimensions,paver() )
end
function clear(shape,dimensions)
	go(shape, dimensions, function() turtle.digDown() end ) 
end
