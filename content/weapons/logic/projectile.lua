local projectile = {}

local weaputil = require("content.weapons.logic.weaputil")
local util = require("lib.self.util")

-- Only affect the target if: the projectile and the target both
-- have a Team component and they are on different teams; or
-- one or both do not have a team component.
--
-- TODO: Projectiles probably affect entities other than
-- just combatants.
local function collision_eligible(projectile, target)
	if projectile.Team and target.Team then
		if projectile.Team == target.Team then
			return false
		else
			return true
		end
	else
		return true
	end
end

---

function projectile.generic(radius, mass, lifetime)
	if not mass then mass = math.pi * radius^2 end

	return {
		Projectile = true,

		Radius = radius,
		Mass = mass,

		Lifetime = lifetime or 10,
		ArenaBounded = 0,

		OnEntityCollision = function(self, world, target, mtv)
			if collision_eligible(self, target) then
				-- Add impact "force".
				target.Velocity = weaputil.calculate_post_impact_velocity(
					self.Mass, self.Velocity, target.Mass, target.Velocity)

				-- If the projectile has OnProjectileCollision
				-- (used for health damage, destroy self, etc.)
				-- and the target is not on the same team, run
				-- the function.
				if self.OnProjectileCollision then
					self:OnProjectileCollision(world, target, mtv)
				end
			end
		end
	}
end

function projectile.bullet(radius, mass, lifetime, damage)
	return util.table.join(
		projectile.generic(radius, mass, lifetime),
		{
			OnProjectileCollision = function(self, world, target, mtv)
				if target.Health then
					target.Health = target.Health - damage
				end

				world:destroyEntity(self)
			end
		}
	)
end

---

return projectile
