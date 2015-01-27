if(deque==nil) then os.loadAPI("/api/deque") end
if(nav==nil) then os.loadAPI("nav") end


local directions="nsewudfblr"
local numbers="1234567890"

local dir_vectors={
	n=vector.new(0,0,-1),
	s=vector.new(0,0,1),
	e=vector.new(-1,0,0),
	w=vector.new(1,0,0),
	u=vector.new(0,1,0),
	d=vector.new(0,-1,0)
}

local function iter_step(step)
	local i =0
	return function()
		i = i + 1
		if(i <= step.num) then 
			return step.dir
		end
		return nil
	end
end

local function iterate(q,f)
	for step in q:iter_left() do
		for dir in iter_step(step) do
			f(dir)
		end
	end
end

function parse(path)
	if (type(path)~="string") then		
		return false, "path must be a string"
	end
	local length = string.len(path)
	local next_dir = {}
	local num = ""
	local q = deque.new()
	
	for i=1,length do
		local c = string.sub(path,i,i)
		if(string.find(directions,c,1,true)) then
			-- its a direction
			next_dir.dir=c
			if(num=="") then	
				next_dir.num=1
			else
				next_dir.num = tonumber(num)
			end
			if(q:length()>0 and q:peek_right().dir==c) then
				local x = q:peek_right()
				x.num = x.num + next_dir.num
			else
				q:push_right(next_dir)
			end
			next_dir={}
			c=""
			num=""
		elseif(string.find(numbers,c,1,true)) then
			num=num..c
		end
	end
	return q
end
function traverse(path,f)
	local q = parse(path)
	iterate(q,f)
end
local function move(d)
	if(d=="l") then
		return turtle.turnLeft()
	end
	if(d=="r") then
		return turtle.turnRight()
	end
	if(d=="f") then
		return turtle.forward()
	end
	if(d=="b") then
		return turtle.back()
	end
	--print("Move "..d)
	return nav.moveDir(dir_vectors[d])
	
	
end
function go(path)
	traverse(path,move)
end

function goTo(pos)
	if (not nav.isCalibrated()) then
		return false, "not calibrated"
	end
	local ttl=100
	local deadend=false
	local thereYet=false
	local dirs = {vector.new(0,1,0),vector.new(1,0,0),vector.new(0,0,1)}
	
	local function move()
		ttl=ttl-1
		local delta = pos - nav.getPos()
		--term.write("delta: "..delta:tostring())
		local _
		if(delta:length()==0) then
			thereYet=true
			return
		end
		for _,dir in pairs(dirs) do
			local movement = vector.new( dir.x * delta.x, dir.y * delta.y, dir.z*delta.z ):normalize()
			term.write(_..movement:tostring().." ")
			if ( movement.x ~=nil and nav.moveDir(movement) ) then				
				--print ("moved "..movement:tostring().. ":"..nav.vectorToBearing(movement))
				return
			end
		end
		deadend=true
	end
	
	while(not thereYet and not deadend and ttl > 0) do
		move()
	end

	return thereYet
end
