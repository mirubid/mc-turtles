local tArgs = {...}
if(route==nil) then os.loadAPI("api/route") end

local function test_step1(path,num,dir)
	local q=route.parse(path)
	local step = q:peek_left()
	assert(step.dir==dir,"dir: expected "..dir)
	assert(step.num==num,"num: expected "..num.." was "..step.num)
end

test_step1("s",1,"s")
test_step1("n",1,"n")
test_step1("e",1,"e")
test_step1("w",1,"w")
test_step1("u",1,"u")
test_step1("d",1,"d")
test_step1("ss",2,"s")
test_step1("2s",2,"s")

test_step1("10n",10,"n")