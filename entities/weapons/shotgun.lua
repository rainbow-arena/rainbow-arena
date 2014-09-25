local class = require("lib.hump.class")

---

local w_projectile = require("entities.weapons.projectile")
local w_shotgun = class{__includes = w_projectile}

---

function w_shotgun:init(arg)
	self.pellets = arg.pellets or 5
	self.spread = arg.spread or math.pi/10

	w_projectile.init(self, arg)
end

function w_shotgun:fire(host, world, pos, dir)
	for pellet = 1, self.pellets do
		local spread = self.spread
		local angle = (love.math.random() - 0.5) * spread

		self:fire_projectile(host, world, pos + dir:perpendicular() * angle * 10, dir:rotated(angle))
	end

	self:apply_shot_effects(host, world, pos, dir)
	self:play_shot_sound(world, host)
end

---

return w_shotgun
