local proj_generic = require("content.weapons.projectiles.generic")

local weaputil = require("content.weapons.logic.weaputil")
local util = require("lib.self.util")

---

return function(radius, mass)
	mass = mass or math.pi * radius^2

	return util.table.join(
		proj_generic(),
		{
			Radius = radius,
			Mass = mass,

			OnProjectileCollision = function(self, world, target, mtv)
				-- Add impact "force".
				target.Velocity = weaputil.calculate_post_impact_velocity(
					self.Mass, self.Velocity, target.Mass, target.Velocity)
			end
		}
	)
end
