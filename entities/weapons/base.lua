local class = require("lib.hump.class")

local weapon = class{}

function weapon:init(arg)
	self.max_heat = arg.max_heat or 2

	self.heat = 0
end

function weapon:start(world, host, pos, dir)

end

function weapon:firing(dt, world, host, pos, dir)

end

function weapon:cease(world, host)

end

function weapon:update(dt, world, host)

end

return weapon
