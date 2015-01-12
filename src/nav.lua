-- navigation
local t= turtle
print ("initializing turtle with nav features")

if(t.__navigator) then return true end

local turn={}
local L=-1 -- left
local R=1 -- right
turn[L]=t.turnLeft
turn[R]=t.turnRight
local fb={}
local F = 1
local B = -1
fb[F]=t.forward
fb[B]=t.back	

local ud={}
local U = 1
local D = -1
ud[U] = t.up
ud[D] = t.down

local bearing=0 -- bearing relative to start bearing, 0=start bearing
local pos = vector.new(0,0,0)

turn.go=function(dir)
	if(dir ~= 1 and dir ~=-1) then
		print ("invalid direction given: "..dir)
	end
	--print ("turning "..dir)
	if( turn[dir]() ) then
		bearing = (bearing + dir) % 4
	end
end
fb.go=function(dir)
	if(dir ~= F and dir ~=B) then
		print ("invalid direction given: "..dir)
	end
	print("horizontal move "..dir)
	if(fb[dir]())then
			-- `north` is in the direction of diminishing Z, east is diminishing X (Y is vertical)
		--print ("updating position. bearing: "..bearing)
		local v = vector.new(bearing%2, 0, 1-(bearing%2) ) * dir
		pos = pos + v
	end
end
ud.go=function(dir)
	if(dir ~= U and dir ~=D) then
		print ("invalid direction given: "..dir)
	end
	print("vertical move "..dir)
	if(ud[dir]())then
		--print ("updating position")
		pos= pos + vector.new(0, dir*1, 0)
	end
end
t.forward = function () fb.go(F)	end
t.back = function() fb.go(B) end

t.turnRight = function() turn.go(R) end
t.turnLeft = function() turn.go(L) end

t.up = function() ud.go(U) end
t.down = function() ud.go(D) end

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
t.__navigator = {}

