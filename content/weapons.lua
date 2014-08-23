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
	pistol = function(cooldown, bullet_radius, bullet_mass, bullet_speed, bullet_damage)
		bullet_mass = bullet_mass or math.pi * bullet_radius^2
		return {
			type = "single",
			fire = function(self, world, host, pos, dir)
				-- Fire projectile
				world:spawnEntity{
					Name = "Bullet",
					Projectile = true,
					Team = host.Team,

					Position = pos + (dir * 5),
					Velocity = bullet_speed * dir + host.Velocity,
					Acceleration = vector.new(0, 0),

					Radius = bullet_radius,
					Mass = bullet_mass,

					Lifetime = 5,
					ArenaBounded = 0,

					CollisionExcludeEntities = {host},
					CollisionExcludeComponents = {"Projectile"},

					EntityCollisionFunction = function(self, world, target, mtv)
						if target.Health then
							target.Health = target.Health - damage
						end

						target.Velocity = calculate_post_impact_velocity(
							self.Mass, self.Velocity, target.Mass, target.Velocity)

						world:destroyEntity(self)
					end
				}

				-- Recoil
				host.Velocity = calculate_recoil_velocity(bullet_mass,
					bullet_speed * dir, host.Mass, host.Velocity)

				-- Cooldown
				self.heat = cooldown
			end
		}
	end
}
