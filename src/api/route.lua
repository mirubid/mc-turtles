if(deque==nil) then os.loadAPI("/api/deque") end
local dir_vectors={
	"n"=vector.new(0,0,-1),
	"s"=vector.new(0,0,1),
	"e"=vector.new(-1,0,0),
	"w"=vector.new(1,0,0),
	"u"=vector.new(0,1,0),
	"d"=vector.new(0,-1,0)
}
local directions="nsewudfblr"
local numbers="123456789"

local function iter_step(step)
	local i =0
	return function()
		i = i + 1
		if(i <= step.num) then 
			return step.dir
		end
		return nil
	end
end

local function iterate(q,f)
	for step in q:iter_left() do
		for dir in iter_step(step) do
			f(dir)
		end
	end
end

function parse(path)
	if (type(path)~="string") then		
		return false, "path must be a string"
	end
	local length = string.len(path)
	local next_dir = {}
	local num = ""
	local q = deque.new()
	
	for i=1,length do
		local c = string.sub(path,i,i)
		if(string.find(directions,c,1,true)) then
			-- its a direction
			next_dir.dir=c
			if(num=="") then	
				next_dir.num=1
			else
				next_dir.num = tonumber(num)
			end
			if(q:length()>0 and q:peek_right().dir==c) then
				local x = q:peek_right()
				x.num = x.num + next_dir.num
			else
				q:push_right(next_dir)
			end
			next_dir={}
			c=""
			num=""
		elseif(string.find(numbers,c,1,true)) then
			num=num..c
		end
	end
	return q
end
function traverse(path,f)
	local q = parse(path)
	iterate(q,f)
end
