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

function inspectedIs(expected,dir)
	-- compare the item in front of the turtle to expected
	if(dir==nil) then dir="" end
	local b, item = turtle["inspect"..dir]()
	
	if b then
		local name = mcname(expected)
		--print("inspected is ["..item.name.."], expecting ["..name.."]")
		return item.name == name
	end
	return false
end
function inspectedIsAny(items,dir)
	if(nil==items) then return false end
	local i, expected
	for i,expected in pairs(items) do
		if(inspectedIs(expected,dir)) then
			return true
		end
	end
	return false
end