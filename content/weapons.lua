local vector = require("lib.hump.vector")

local function calculate_recoil_velocity(projectile_mass, projectile_velocity,
	firer_mass, firer_velocity)

	return firer_velocity - ((projectile_mass * (projectile_velocity)) / firer_mass)
end

local function calculate_post_impact_velocity(projectile_mass, projectile_velocity,
	target_mass, target_velocity)

	return (projectile_mass * projectile_velocity + target_mass * target_velocity)
		/ (projectile_mass + target_mass)
end

return {
	pistol = function(bullet_radius, bullet_speed, cooldown, damage)
		return {
			type = "single",
			fire = function(self, world, host, pos, dir)
				local shot_velocity = bullet_speed * dir + host.Velocity

				-- Fire projectile
				world:spawnEntity{
					Name = "Bullet",
					Projectile = true,
					Team = host.Team,

					Position = pos + (dir * 5),
					Velocity = shot_velocity,
					Acceleration = vector.new(0, 0),

					Radius = bullet_radius,

					Lifetime = 5,
					ArenaBounded = 0,

					CollisionExcludeEntities = {host},
					CollisionExcludeComponents = {"Projectile"},

					EntityCollisionFunction = function(self, world, target, mtv)
						if target.Health then
							target.Health = target.Health - damage
						end

						target.Velocity = calculate_post_impact_velocity(
							self.Radius, self.Velocity, target.Radius, target.Velocity)

						world:destroyEntity(self)
					end
				}

				-- Recoil
				host.Velocity = calculate_recoil_velocity(bullet_radius,
					bullet_speed * dir, host.Radius, host.Velocity)

				-- Cooldown
				self.heat = cooldown
			end
		}
	end
}
