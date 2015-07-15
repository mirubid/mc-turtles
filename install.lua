local targs = { ... }
local host="http://mirubid.github.io/mc-turtles/"
if(#targs > 0) then
	host = targs[1]
end
print("loading from " .. host .. "...")
local manifest = http.get(host .. "manifest.txt")
if(manifest==nil) then
	print("could not load " .. host .. "manifest.txt")
	return
end
print("status " .. manifest.getResponseCode())

if (not fs.exists("/api")) then
	fs.makeDir("/api")
end
local function dl(fn)
	local src = http.get(host .."src/" .. fn)
	local lfn = string.gsub(fn,"\.lua$","")
	print('status ' .. src.getResponseCode())
	local content = src.readAll()
	local f = fs.open(lfn,"w")
	f.write(content)
	f.close()
end

local fn = manifest.readLine()
while(fn) do
	print("file " .. fn)
	dl(fn)
	fn = manifest.readLine()
end
manifest.close()
print("done")
os.reboot()