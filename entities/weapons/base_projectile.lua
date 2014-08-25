local vector = require("lib.hump.vector")
local weaponutil = require("util.weapon")
local util = require("lib.self.util")

---

return function(projectile_prototype, projectile_speed, cooldown)
	return {
		fire = function(self, world, host, pos, dir)
			self:do_fire(world, host, pos, dir)
		end,

		---

		do_fire = function(self, world, host, pos, dir)
			local projectile = self:fire_projectile(world, host, pos, dir)

			-- Recoil
			if host.Mass and projectile.Mass then
				self:apply_recoil(host, self:get_projectile_speed(), projectile.Mass, dir)
			end

			-- Cooldown
			self.heat = self:get_cooldown()
		end,

		---

		fire_projectile = function(self, world, host, pos, dir)

			local projectile = world:spawnEntity(
				util.table.join(
					self:get_projectile(),
					{
						Position = pos + dir,
						Velocity = self:get_projectile_speed() * dir + host.Velocity,
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

			return projectile
		end,

		apply_recoil = function(self, host, projectile_speed, projectile_mass, projectile_dir)
			host.Velocity = weaponutil.calculate_recoil_velocity(projectile_mass,
				projectile_speed * projectile_dir, host.Mass, host.Velocity)
		end,

		get_projectile = function(self)
			return projectile_prototype
		end,

		get_projectile_speed = function(self)
			return projectile_speed
		end,

		get_cooldown = function(self)
			return cooldown
		end
	}
end
