local class = require("lib.hump.class")

local weapon = class{}

function weapon:init(max_heat)
	self.heat = 0
	self.max_heat = max_heat or 2
end

function weapon:start(world, host, pos, dir)

end

function weapon:update(dt, world, host, pos, dir)

end

function weapon:cease(world, host)

end

return weapon
