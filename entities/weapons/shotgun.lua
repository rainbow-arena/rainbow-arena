local class = require("lib.hump.class")

---

local w_projectile = require("entities.weapons.projectile")
local w_shotgun = class{__includes = w_projectile}

---

function w_shotgun:init(arg)
	self.shotgun_pellets = arg.shotgun_pellets or 5
	self.shotgun_spread = arg.shotgun_spread or math.pi/3

	w_projectile.init(self, arg)
end

function w_shotgun:fire(host, world, pos, dir)
	for pellet = 1, self.shotgun_pellets do
		local spread = self.shotgun_spread
		local angle = (love.math.random() - 0.5) * (spread/2)

		w_projectile.fire(self, host, world, pos, dir:rotated(angle))
	end
end

---

return w_shotgun
