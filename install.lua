local targs = { ... }
local host="http://mirubid.github.io/mc-turtles/"
if(#targs > 0) then
	host = targs[1]
end
print("loading from " .. host .. "...")
local manifest = http.get(host .. "manifest.txt")

if (not fs.exists("/api")) then
	fs.makeDir("/api")
end
local function dl(fn)
	local src = http.get(host .."src/" .. fn)
	local lfn = string.gsub(fn,"\.lua$","")
	local f = fs.open(lfn,"w")
	f.write(src.readAll())
	f.close()
end

local fn = manifest.readLine()
while(fn) do
	print("file " .. fn)
	dl(fn)
	fn = manifest.readLine()
end
print(manifest.readAll())
print("done")