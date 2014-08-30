local class = require("lib.hump.class")
local util = require("lib.self.util")

---

local map = util.math.map

---

local w_minigun = require("entities.weapons.minigun")
local w_tripleminigun = class{__includes = w_minigun}

---

function w_tripleminigun:init(arg)
	self.barrel = -1

	w_minigun.init(self, arg)
end

function w_tripleminigun:fire(host, world, pos, dir)
	pos = pos + dir:perpendicular() * self.barrel * 10

	w_minigun.fire(self, host, world, pos, dir)

	self.barrel = self.barrel + 1
	if self.barrel > 1 then
		self.barrel = -1
	end
end

---

return w_tripleminigun
