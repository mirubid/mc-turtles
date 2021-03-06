if(nil==util) then os.loadAPI("util") end

function itemIs(index,expected)
	-- check whether the item in the inventory at slot index matches expected
	item = turtle.getItemDetail(index)
	if(item==nil) then
		print "no item there"
		return false
	end
	local name = util.mcname(expected)
	--print("inventory is ["..item.name.."], expecting ["..name.."]")
	return item.name == name
end

function itemMatches(index,pattern)
	-- check whether the item in the inventory at slot index matches expected
	item = turtle.getItemDetail(index)
	if(item==nil) then
		print "no item there"
		return false
	end

	if (item.name:find(pattern)) then
		return true
	else
		return false
	end
end
function itemMatchesAny(index,items)
	if(nil==items) then return false end
	for _,i in pairs(items) do
		if(itemMatches(index,i)) then
			return true
		end
	end
	return false
end
function itemIsAny(index,items)
	if(nil==items) then return false end
	for i,_ in pairs(items) do
		if(itemIs(index,i)) then
			return true
		end
	end
	return false
end

function transferExtras(index)
-- transfer stuff from other slots to the target slot
	if(turtle.getItemSpace(index)==0) then
		print("the slot is already full")
		return
	end
	local selected=turtle.getSelectedSlot()

	for i = 1,16 do
		if i~=index then
			turtle.select(i)
			if(turtle.compareTo(index)) then
				turtle.transferTo(index,turtle.getItemSpace(index))
				turtle.select(selected)
			end
			if(turtle.getItemSpace(index)==0)then
				return
			end
		end
	end
end
