-- pave

local targs = {...}
local dimensions = deque.new()
local i,v,shape,x,y
local start_pos=nav.getPos()
local start_bearing=nav.getBearing()

local shapes={
	rectangle=rect_iter
}
if(#targs == 0) then
	shape="rectangle"
	dimensions.push_right(8)
	dimensions.push_right(8)
	return
end
for i,v in pairs(targs) do
	local n = tonumber(v)
	if(n) then 
		dimensions.push_right(n) 	
	else
		shape = v
	end
end


print ( "paving a "..shape)

function rect_iter(dimensions,f)
	local z,x= dimensions[0], dimensions[1]
	local x_bearing = 1
	if ( not z or not x) then
		print("two dimensions required")
		return nil
	end
	
	z = math.abs(z)
	if(x<0) then
		x_bearing=-1
	end
	local i,j,di,dj = 0,0,1,1
	local function z()
		i = i + dj
		if(i>z or i<1) then
			dj = -dj
			return false
		end
		local bearing = start_bearing
		if(dj < 0) then
			bearing = (start_bearing + 2) % 4
		end
		if( nav.moveDir(bearing) ) then
			f()
			return true
		else
			return false, "failed to move"
		end
	end
	local function z()
		j = j + dj
		if (j>math.abs(x) ) then
			return false
		end
		if(nav.moveDir(x_bearing))
		f()
		return true
	end
	return function()
		return (z() or x())
	end
end

function wall_iter(dimensions,f)
	return nil
end