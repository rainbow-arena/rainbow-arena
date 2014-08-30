local class = require("lib.hump.class")

---

local w_base = class{}

---

function w_base:init(arg)
	self.max_heat = arg.max_heat or 2

	self.heat = 0
end

function w_base:start(world, host, pos, dir)

end

function w_base:firing(dt, world, host, pos, dir)

end

function w_base:cease(world, host)

end

function w_base:update(dt, world, host)

end

---

return w_base
