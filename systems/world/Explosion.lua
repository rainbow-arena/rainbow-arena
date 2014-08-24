local circle = require("logic.circle")

local aabb = circle.aabb
local ceil = math.ceil

return {
	systems = {
		{
			name = "UpdateExplosion",
			requires = {"Position", "Explosion"},
			update = function(entity, world, dt)
				local exp = entity.Explosion
				assert(exp.force and exp.radius, "Explosion component missing field(s)!")

				-- Apply force and damage to nearby entities.
				local force = exp.force
				local damage = exp.damage
				local radius = exp.radius

				for affected in pairs(world.hash:get_objects_in_range(
					aabb(radius, entity.Position.x, entity.Position.y)))
				do
					local dist_vec = (affected.Position - entity.Position)
					local dist = dist_vec:len()
					local impact = 1 - (dist/radius)

					if impact > 0 then
						if affected.Velocity then
							-- Apply explosion force.
							local dir = dist_vec:normalized()
							affected.Velocity = affected.Velocity + impact * (force / affected.Mass) * dir
						end

						if damage and affected.Health then
							-- Apply health damage.
							affected.Health = affected.Health - ceil(impact * damage)
						end
					end
				end

				entity.Explosion = nil
			end
		}
	}
}
