-- navigation
if(nav) then
	print("nav already loaded")
	return true
end
local t= turtle
print ("initializing turtle with nav features")



local turn={}
local L=-1 -- left
local R=1 -- right
turn[L]=t.turnLeft
turn[R]=t.turnRight
local fb={}
local F = -1
local B = 1
fb[F]=t.forward
fb[B]=t.back	

local ud={}
local U = 1
local D = -1
ud[U] = t.up
ud[D] = t.down

local bearing=0 -- bearing relative to start bearing, 0=start bearing
local pos = vector.new(0,0,0)
local calibrated=false

vectors={
	up=vector.new(0,1,0),
	down = vector.new(0,-1,0)
}

turn.go=function(dir)
	if(dir ~= 1 and dir ~=-1) then
		print ("invalid direction given: "..dir)
	end
	--term.write ("turning "..dir..";")
	if( turn[dir]() ) then
		--term.write(bearing)
		bearing = (bearing + dir) % 4
		--print(" -> "..bearing)
		return true
	else
		return false
	end
end
fb.go=function(dir)
	if(dir ~= F and dir ~=B) then
		print ("invalid direction given: "..dir)
	end
	--term.write("fb.go("..dir..") ")
	if(fb[dir]())then
			-- `north` is in the direction of diminishing Z, east is diminishing X (Y is vertical)
		--print ("updating position. bearing: "..bearing)
		local v = bearingToVector(bearing) * -dir
		--term.write(pos:tostring().." -> ")
		pos = pos + v
		--term.write(pos:tostring().." (dir:".. v:tostring()..")")
		return true
	end
	return false
end
ud.go=function(dir)
	if(dir ~= U and dir ~=D) then
		print ("invalid direction given: "..dir)
		return false, "invalid direction"
	end
	--print("vertical move "..dir)
	if(ud[dir]())then
		--print ("updating position")
		pos= pos + vector.new(0, dir*1, 0)
		return true
	end
	return false
end
t.forward = function () return fb.go(F)	end
t.f=t.forward
t.back = function() return fb.go(B) end
t.b=t.back

t.turnRight = function() return turn.go(R) end
t.r=t.turnRight
t.turnLeft = function() return turn.go(L) end
t.l=t.turnLeft

t.up = function() ud.go(U) end
t.u = t.up
t.down = function() ud.go(D) end
t.d = t.down

t.getBearing = function() return bearing end
t.getPos = function() return pos end
function getPos()
	return pos
end
function getBearing()
	return bearing
end


function zero()
	bearing=0
	pos = vector.new(0,0,0)
	print ("position and bearing reset to zero")
end

function vectorToBearing(v)
	-- convert a direction vector to a bearing
	return math.abs(v.z) * (1+v.z) + math.abs(v.x) * (2 + v.x)
end



function moveBearing(rotation)
	-- rotation: difference between target bearing and current bearing
	--print("moveInBearing "..rotation);
	if(rotation==0) then		
		--print("F")
		return fb.go(F)
	end
	local abs_r = math.abs(rotation)
	if(abs_r==2)then
		--print("B")
		return fb.go(B)
	end
	if(rotation==3 or rotation==-1) then
		--term.write("L")
		turn.go(L)
	else
		--term.write("R")
		turn.go(R)
	end
	--print("F")
	return fb.go(F)
end

function bearingToVector(bearing)
	if(bearing<-3) then error("bearing must be between -3 and 3 inclusive") end
	-- convert a bearing to a direction vector
	bearing = (4+bearing) % 4
	local x,z = ( bearing%2), (bearing%2)
	local mult =  1
	if(bearing < 2) then
		mult=-1
	end
	return vector.new( (bearing%2), 0, 1-bearing%2 ) * mult
end

function face(posV)
	-- face the cell at the specified position
	local dirV = posV - pos
	if( dirV:length() > 1) then	
		return false, "non-adjacent movement",""
	end
	if(dirV:length()==0) then
		return false, "meaningless facement","" -- we're already there
	end
	if(0~=dirV.y) then
		local dir="Up"
		if(dirV.y<0) then dir="Down" end
		return false, "vertical", dir
	end
	local targetBearing=vectorToBearing(dirV);
	if ( faceBearing(targetBearing) ) then
		return true,nil,""
	end
	return false,"?",""
end

function faceBearing(targetBearing)
	local rotation = (targetBearing - bearing + 4) % 4
	if(rotation==3)then
		return turn.go(L)
	end
	local i
	for i = 1,rotation do 
		if(false==turn.go(R) ) then return false end
	end
	return true
end


function moveDir(dirV)
	-- move in direction dirV
	--print("move "..dirV:tostring())
	if(dirV==nil) then
		return false
	end
	if(type(dirV)=="number")then
		return moveDir( bearingToVector(dirV) )
	end
	
	if( dirV:length() > 1) then
		--print("can't move from "..pos:tostring().." to "..posV:tostring()..". (non-adjacent)")
		return false, "non-adjacent movement"
	end
	if(dirV:length()==0) then
		return true -- we're already there
	end
	if(0~=dirV.y) then
		-- vertical travel
		return ud.go(dirV.y)
	end
	
	local targetBearing =  vectorToBearing(dirV)
	
	local rotation = targetBearing - bearing
	
	return moveBearing(rotation)
end

function moveTo(posV)
	-- move to cell at position posV
	local dirV = posV - pos
	return moveDir(dirV)
end

function calibrate()
	local x,y,z = gps.locate()
	if(nil==x) then
		return nil, "gps not available"
	end
	local gps1=vector.new(x,y,z)
	local function findSpace()
		local i
		for i=0,3 do
			if ( not turtle.detect()) then
				return true, i
			end
			turtle.turnRight()
		end
		return false
	end
	
	local space_found,rotation = findSpace()
	
	turtle.forward()
	
	local x2,y2,z2 = gps.locate()
	if(nil==x2) then
		turtle.back()
		return nil,"gps not available"
	end
	gps2=vector.new(x2,y2,z2)
	
	bearing = vectorToBearing(gps2-gps1)
	pos = gps2
	calibrated=true
	-- now go back where we started
	
	turtle.back()
	faceBearing(-rotation)
	
end

function isCalibrated()
	return calibrated
end