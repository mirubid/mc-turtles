function mealIt(item)
	local count=0
	print ("applying bonemeal")
	while true do
		turtle.select(bonemealIndex)
		if 0==turtle.getItemCount() then
			print( "ran out of bonemeal at "..bonemealIndex)
			return false, count
		end
		turtle.place()
		count = count + 1
		-- check whether the tree grew
		if( inspectedIs(names.log) ) then
			print( "a tree grew after "..count.." attempts")
			return true, count
		end
		os.sleep(1)
	end
end
function plantSapling()
	turtle.select(saplingIndex)
	if 0==turtle.getItemCount() then
		print ("No more saplings in slot"..saplingIndex)
		os.exit(1) -- for now, we don't have a script to reload saplings
		return false
	end
	print("planting a sapling")
	return turtle.place()
end
-- check to make sure there is bonemeal and saplings in the inventory at the expected slots
if(not itemIs(bonemealIndex,names.bonemeal)) then
	print ("Put bonemeal in slot #"..bonemealIndex)
	return false
end
if(not itemIs(saplingIndex,names.sapling)) then
	print( "Put sapling in slot #"..saplingIndex)
	return false
end
local b,item = turtle.inspect()
if(b) then
	if(item.name ~= mcname(names.sapling)) then
		print "Put me in front of an empty dirt block (or a sapling)"
		return false
	end
end
--BLA BLA BLA TROLL TROLL TROOOOOLLLLLLLL
while true do
	print("growing trees")
	print('fuel level:'..turtle.getFuelLevel())
	local b, item = turtle.inspect()
	if(not b) then
		if (not plantSapling()) then
			-- sapling not planted
		end
	elseif (item.name == mcname(names.sapling)) then
		if( not mealIt()) then
			-- we run out of bonemeal
		end
	else
		-- something blocking, probably a tree. later, we'll add code for chopping the tree
		print("something there ("..item.name.."), waiting for it to be cleared")
		while turtle.detect() do 
			print "waiting for the tree (or whatever) to be cleared"
			os.sleep(15) 
		end
	end
end





