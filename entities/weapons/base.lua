local class = require("lib.hump.class")

local weapon = class{}

function weapon:init(max_heat)
	self.max_heat = max_heat
end

function weapon:add_heat(n)
	self.heat = self.heat + n
end

function weapon:start(world, host, pos, dir)

end

function weapon:update(dt, world, host, pos, dir)

end

function weapon:cease(world, host)

end

return weapon
