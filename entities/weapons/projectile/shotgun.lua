local wep_projectile_single = require("entities.weapons.projectile.single")

---

local wep_projectile_shotgun = {}

---

function wep_projectile_shotgun.new(args)
	local w = wep_projectile_single.new(args)

	function w:fire(host, world)
		self:fire_when_ready(host, world)

		wep_projectile_single.fire(self, host, world)
	end

	return w
end

---

return wep_projectile_shotgun
