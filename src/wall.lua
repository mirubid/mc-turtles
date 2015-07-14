-- pave
if(nil==paver) then os.loadAPI("api/paver") end

local shape, dimensions = paver.parseArgs({...})

paver.wall(dimensions)