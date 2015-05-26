local wep_projectile_base = require("entities.weapons.projectile.base")

---

local wep_projectile_single = {}

---

function wep_projectile_single.new(args)
	local w = wep_projectile_base.new(args)

	function w:fire(host, world)
		self:fire_when_ready(host, world)

		wep_projectile_base.fire(self, host, world)
	end

	return w
end

---

return wep_projectile_single
