-- utilities for other scripts

names={}
names.dirt="dirt"
names.log="log"
names.sapling="sapling"
names.bonemeal="dye"

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
