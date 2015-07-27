local wep_projectile_base = require("entities.weapons.projectile.base")

---

local wep_projectile_single = {}

---

function wep_projectile_single.new(args)
	local w = wep_projectile_base.new(args)

	function w:fire(host, world)
		if self:can_fire(host, world) then
			local proj = self:fire_projectile(host, world)
			self:fire_effect(host, world, proj)
			self:fire_done(host, world)
		end

		wep_projectile_base.fire(self, host, world)
	end

	return w
end

---

return wep_projectile_single
