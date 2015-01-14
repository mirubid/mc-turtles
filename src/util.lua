-- utilities for other scripts

names={
  dirt="dirt",
  log="log",
  sapling="sapling",
  bonemeal="dye",
  leaves="leaves"
}
function mcname(name) 
	return "minecraft:"..name 
end
names.mc=mcname

function inspectedIs(expected)
	-- compare the item in front of the turtle to expected
	local b, item = turtle.inspect()
	if b then
		local name = mcname(expected)
		--print("inspected is ["..item.name.."], expecting ["..name.."]")
		return item.name == name
	end
	return false
end
function inspectedIsAny(index,items)
	if(nil==items) then return false end
	for i,_ in pairs(items) do
		if(inspectedIs(index,i)) then
			return true
		end
	end
	return false
end