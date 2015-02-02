-- pave
if(nil==paver) then os.loadAPI("api/paver") end

local shape, dimensions, interval = paver.parseArgs({...})

paver.ceiling(shape,dimensions,interval)