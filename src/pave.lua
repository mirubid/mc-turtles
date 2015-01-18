-- pave
if(nil==deque) then os.loadAPI("deque") end
local targs = {...}
local dimensions = deque.new()
local i,v,shape,x,y
local start_pos=nav.getPos()
local start_bearing=nav.getBearing()


print ("starting pave")
if(#targs == 0) then
	shape="rectangle"
	dimensions:push_right(8)
	dimensions:push_right(8)
end
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

print ( "paving a "..shape)
function pave_down()
	turtle.placeDown()
end
function rect_iter(dimensions,f)
	local z,x= dimensions[1], dimensions[2]
	local x_bearing = 1
	if ( not z or not x) then
		print("two dimensions required")
		return nil
	end
	
	z = math.abs(z)
	print(z.."x"..x.." rectangle")
	
	if(x<0) then
		x_bearing=-1
	end
	local i,j,di,dj = 01,1,1
	local function iter_z()
		i = i + di
		
		if(i>z or i<1) then
			di = -di
			return nil
		end
		print("z: "..i..","..j.."("..di..")")
		local bearing = start_bearing
		if(di < 0) then
			bearing = (start_bearing + 2) % 4
		end
		if( nav.moveDir(bearing) ) then
			f()
			return true
		else
			return nil, "failed to move"
		end
	end
	local function iter_x()
		j = j + dj
		if (j>math.abs(x) ) then
			return nil
		end
		print("x: "..i..","..j.."("..dj..")"..x_bearing)
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

function wall_iter(dimensions,f)
	return nil
end
local shapes={
	rectangle=rect_iter
}
local _
for _ in shapes[shape](dimensions,function() os.sleep(2) end) do end