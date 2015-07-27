local wep_projectile_base = require("entities.weapons.projectile.base")

---

local wep_projectile_shotgun = {}

---

function wep_projectile_shotgun.new(args)
	local w = wep_projectile_base.new(args)

	w.shots = args.shots or 2

	function w:fire(host, world)
		if self:can_fire(host, world) then
			for i = 1, self.shots do
				local proj = self:fire_projectile(host, world)
				self:fire_effect(host, world, proj)
			end

			self:fire_done(host, world)
		end

		wep_projectile_base.fire(self, host, world)
	end

	return w
end

---

return wep_projectile_shotgun
