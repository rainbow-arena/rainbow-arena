local wep_projectile_base = require("entities.weapons.projectile.base")

---

local wep_projectile_auto = {}

---

function wep_projectile_auto.new(args)
	local w = wep_projectile_base.new(args)

	function w:firing(host, world, dt)
		self:fire_when_ready(host, world)

		wep_projectile_base.firing(self, host, world, dt)
	end

	return w
end

---

return wep_projectile_auto
