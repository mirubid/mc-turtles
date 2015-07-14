local host="http://mirubid.github.io/mc-turtles/"
print("loading from " .. host .. "...")
local manifest = http.get(host .. "manifest.txt")
print(manifest.readAll())
print("done")