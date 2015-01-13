if(nil==nav) then os.loadAPI("nav") end
if(nil==util ) then os.loadAPI("util") end
if(nil==inventory) then os.loadAPI("inventory") end
local names = util.names

local bonemealIndex=5
local saplingIndex=1
local treesChopped=0 -- the number of trees that have been chopped
local treesPlanted=0
local bonemealUsed=0

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
		if( util.inspectedIs(names.log) ) then
			print( "a tree grew after "..count.." attempts")
			return true, count
		end
		os.sleep(2)
	end
end
function plantSapling()
	turtle.select(saplingIndex)
	if 0==turtle.getItemCount() then
		inventory.transferExtras(saplingIndex,names.sapling)
	end
	if 0==turtle.getItemCount() then
		print ("No more saplings in slot"..saplingIndex)
		return false
	end
	print("planting a sapling")
	return turtle.place()
end
function transferBonemeal()
	inventory.transferExtras(bonemealIndex,names.bonemeal)
-- transfer bonemeal from other slots to the bm slot
end
-- check to make sure there is bonemeal and saplings in the inventory at the expected slots
if(not inventory.itemIs(bonemealIndex,names.bonemeal)) then
	transferBonemeal()
end
if(not inventory.itemIs(bonemealIndex,names.bonemeal)) then
	print ("Put bonemeal in slot #"..bonemealIndex)
	return false
end
if(not inventory.itemIs(saplingIndex,names.sapling)) then
	inventory.transferExtras(saplingIndex,names.sapling)
end
if(not inventory.itemIs(saplingIndex,names.sapling)) then
	print( "Put sapling in slot #"..saplingIndex)
	return false
end
local b,item = turtle.inspect()
if(b) then
	if(item.name ~= util.mcname(names.sapling)) then
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
			print("plant sapling failed")
			os.sleep(15)
		else
			treesPlanted = treesPlanted+1
		end
	elseif (item.name == util.mcname(names.sapling)) then
		local status, count = mealIt()
		if( not status) then
			-- we run out of bonemeal
			transferBonemeal()
		else
			bonemealUsed = bonemealUsed + count
		end
	else
		-- something blocking, probably a tree. later, we'll add code for chopping the tree
		print("something there ("..item.name.."), waiting for it to be cleared")
		while turtle.detect() do 
			print "waiting for the tree (or whatever) to be cleared"
			print(string.format('trees planted: %d, bonemeal used:%d',treesPlanted,bonemealUsed))
			os.sleep(15) 
		end
	end
end





