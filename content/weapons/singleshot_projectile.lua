local vector = require("lib.hump.vector")
local util = require("lib.self.util")
local weaputil = require("content.weapons.logic.weaputil")

---

return function(cooldown, projectile_speed, projectile_prototype)
	return {
		type = "single",
		fire = function(self, world, host, pos, dir)
			-- Fire projectile
			local projectile = world:spawnEntity(
				util.table.join(
					projectile_prototype,
					{
						Position = pos + dir,
						Velocity = projectile_speed * dir + host.Velocity,
						Team = host.Team
					}
				)
			)

			-- Add host to collision exclusion list.
			if not projectile.CollisionExcludeEntities then
				projectile.CollisionExcludeEntities = {host}
			else
				table.insert(projectile.CollisionExcludeEntities, host)
			end

			-- Recoil
			if projectile.Mass then
				host.Velocity = weaputil.calculate_recoil_velocity(projectile.Mass,
					projectile_speed * dir, host.Mass, host.Velocity)
			end

			-- Cooldown
			self.heat = cooldown
		end
	}
end
