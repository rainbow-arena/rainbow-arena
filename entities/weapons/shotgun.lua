local class = require("lib.hump.class")

---

local w_projectile = require("entities.weapons.projectile")
local w_shotgun = class{__includes = w_projectile}

---

function w_shotgun:init(arg)
	self.pellets = arg.pellets or 5
	arg.spread = arg.spread or math.pi/10

	w_projectile.init(self, arg)
end

function w_shotgun:fire(host, world, pos, dir)
	local _
	for pellet = 1, self.pellets do
		_, pos, dir = self:fire_projectile(host, world, pos, dir)
	end

	self:apply_shot_effects(host, world, pos, dir)
	self:play_shot_sound(world, host)
end

---

return w_shotgun
