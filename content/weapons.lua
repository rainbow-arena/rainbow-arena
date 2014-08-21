local vector = require("lib.hump.vector")

return {
	pistol = function(bullet_size, muzzle_velocity, cooldown, damage, recoil)
		return {
			type = "single",
			fire = function(self, world, host, pos, dir)
				local shot_velocity = muzzle_velocity * dir + host.Velocity

				-- Fire projectile
				world:spawnEntity{
					Name = "Bullet",
					Team = host.Team,

					Position = pos + (dir * 5),
					Velocity = shot_velocity,
					Acceleration = vector.new(0, 0),

					Radius = bullet_size,

					Lifetime = 5,
					ArenaBounded = 0,

					CollisionExclude = {host},
					EntityCollisionFunction = function(self, world, target, mtv)
						if target.Health then
							target.Health = target.Health - damage
						end

						target.RecoilForce = recoil * dir -- TODO: how to calculate recoil from shot velocity?

						world:destroyEntity(self)
					end
				}

				-- Recoil
				host.RecoilForce = recoil * -dir

				-- Cooldown
				self.heat = cooldown
			end
		}
	end
}
