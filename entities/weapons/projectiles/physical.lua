local proj_generic = require("content.weapons.projectiles.generic")

local weaputil = require("content.weapons.logic.weaputil")
local util = require("lib.self.util")

---

return function(radius, mass, color)
	mass = mass or math.pi * radius^2

	local proj = util.table.join(
		proj_generic(),
		{
			Radius = radius,
			Mass = mass,
			Color = color
		}
	)

	table.insert(proj.OnProjectileCollision, function(self, world, target, mtv)
		-- Add impact "force".
		target.Velocity = weaputil.calculate_post_impact_velocity(
			self.Mass, self.Velocity, target.Mass, target.Velocity)
	end)

	return proj
end
