local vector = require("lib.hump.vector")

return {
	pistol = function(muzzle_velocity, cooldown, damage)
		return {
			type = "single",
			fire = function(self, world, host, pos, dir)
				-- Fire projectile
				world:spawnEntity{
					Name = "Bullet",
					Team = host.Team,

					Position = pos + (dir * 5),
					Velocity = muzzle_velocity * dir,
					Acceleration = vector.new(0, 0),

					Radius = 4,

					Lifetime = 5,
					ArenaBounded = 0,

					CollisionExclude = {host},
					EntityCollisionFunction = function(self, world, target)
						print(self.Name .. " collide " .. target.Name)
						if target.Health then
							target.Health = target.Health - damage
						end
						world:destroyEntity(self)
					end
				}

				-- Recoil
				host.RecoilAcceleration = -muzzle_velocity * dir

				-- Cooldown
				self.heat = cooldown
			end
		}
	end
}
