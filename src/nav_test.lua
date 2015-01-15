function expect(pos)
	local cp = nav.getPos():tostring()
	local p = pos:tostring()
	assert(p==cp,p.." vs "..cp)
end
function coord(x,y,z)
	expect(vector.new(x,y,z))
end

local b
local locs={}
for b=0,3 do
	local dir = nav.bearingToVector(b)
	locs[b]=dir
	term.write(dir:tostring().."/")
end
nav.zero()
home = vector.new(0,0,0)
coord(0,0,0)

turtle.forward()
coord(0,0,-1)

turtle.back()
expect(home)

for b=0,3 do
	local dir = nav.bearingToVector(b)
	print("moveTo "..dir:tostring())
	nav.zero()1
	assert(nav.moveTo(dir))
	expect(dir)
	nav.moveTo(home)
	expect(home)	
	print("")
end

print("ok")
