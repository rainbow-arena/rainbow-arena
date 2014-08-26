local timer = require("lib.hump.timer")

local circleutil = require("util.circle")

local aabb = circleutil.aabb
local ceil = math.ceil

return {
	systems = {
		{
			name = "DoExplosion",
			requires = {"Position", "Explosion"},
			update = function(entity, world, dt)
				local exp = entity.Explosion
				assert(exp.radius and exp.speed and exp.force, "Explosion component missing field(s)!")

				-- Apply force and damage to nearby entities after a delay.
				local radius = exp.radius
				local speed = exp.speed
				local force = exp.force
				local damage = exp.damage

				for affected in pairs(world.hash:get_objects_in_range(
					aabb(radius, entity.Position.x, entity.Position.y)))
				do
					local dist_vec = (affected.Position - entity.Position)
					local dist = dist_vec:len()
					local impact = 1 - (dist/radius)
					local delay = (dist/speed) / 2 -- Blast propagates twice as fast as particle speed because I said so.

					if impact > 0 then
						local dir = dist_vec:normalized()
						timer.add(delay, function()
							-- ColorPulse entity.
							if affected.Color then affected.ColorPulse = impact end

							if affected.Velocity then
								-- Apply explosion force.
								affected.Velocity = affected.Velocity + impact * (force / affected.Mass) * dir
							end

							if damage and affected.Health then
								-- Apply health damage.
								affected.Health = affected.Health - ceil(impact * damage)
							end
						end)
					end
				end

				entity.Explosion = nil
			end
		}
	}
}
