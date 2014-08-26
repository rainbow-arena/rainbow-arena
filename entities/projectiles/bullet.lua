local proj_physical = require("entities.projectiles.physical")

local util = require("lib.self.util")

---

return function(radius, damage, color, mass)

	local proj = proj_physical(radius, color or {255, 255, 0}, mass)

	table.insert(proj.OnProjectileCollision, function(self, world, target, mtv)
		-- Damage entities hit by the bullet and destroy the bullet.
		if target.Health then
			target.Health = target.Health - damage
		end

		world:destroyEntity(self)
	end)

	return proj
end
