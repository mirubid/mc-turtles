--build
local targs = {...}
if( #targs == 0) then
	print "use some arguments"
	return
end

local function Stairs(dir, height)
	local digV,moveV,place
	height=tonumber(height)
	
	print ("building stairs "..dir.." "..height)
	if(not (dir=="u" or dir=="d")) then
		return nil, "specify u or d"
	end
	if (dir=="u") then
		turtle.digDown()
		turtle.down()
		digV=turtle.digUp
		moveV=turtle.up
		place= turtle.placeUp
	end
	if(dir=="d") then
		digV=turtle.digDown
		moveV=turtle.down
		place = function()
			turtle.turnRight()
			turtle.turnRight()
			turtle.placeUp()
			turtle.turnRight()
			turtle.turnRight()
		end
		digV()
		moveV()
		digV()
		moveV()
	end
	
	local i
	for i =1,height do
		
		place()
		if(i<height) then
			if(turtle.detect()) then
				turtle.dig()
			end
			turtle.forward()
			digV()
			moveV()
		end
	end
	
end
print( targs[1])
print (targs[2])

if (targs[1] == "stairs") then
	Stairs(targs[2],targs[3])
end