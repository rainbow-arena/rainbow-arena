local weaputil = {}

local vector = require("lib.hump.vector")

---

function weaputil.calculate_recoil_velocity(projectile_mass, projectile_velocity,
	firer_mass, firer_velocity)

	return firer_velocity - ((projectile_mass * projectile_velocity) / firer_mass)
end

function weaputil.calculate_post_impact_velocity(projectile_mass, projectile_velocity,
	target_mass, target_velocity)

	return (projectile_mass * projectile_velocity + target_mass * target_velocity)
		/ (projectile_mass + target_mass)
end

---

return weaputil
