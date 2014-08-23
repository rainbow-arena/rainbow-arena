local vector = require("lib.hump.vector")
local util = require("lib.self.util")
local weaputil = require("content.weapons.logic.weaputil")

---

return function(cooldown, projectile_speed, projectile_prototype)
	return {
		type = "single",
		fire = function(self, world, host, pos, dir)
			-- Fire projectile
			world:spawnEntity(
				util.table.join(
					projectile_prototype,
					{
						Projectile = true,

						CollisionExcludeEntities = {host},
						CollisionExcludeComponents = {"Projectile"},

						Position = pos + dir,
						Velocity = projectile_speed * dir + host.Velocity,
						Team = host.Team
					}
				)
			)

			-- Recoil
			if projectile_prototype.Mass then
				host.Velocity = weaputil.calculate_recoil_velocity(projectile_prototype.Mass,
					projectile_speed * dir, host.Mass, host.Velocity)
			end

			-- Cooldown
			self.heat = cooldown
		end
	}
end
