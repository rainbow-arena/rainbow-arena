local vector = require("lib.hump.vector")

---

return {
	systems = {
		{
			name = "ArenaCollision",
			requires = {"Position", "Velocity", "Radius", "ArenaBounded"},
			update = function(entity, world, dt)
				local pos, radius, vel = entity.Position, entity.Radius, entity.Velocity

				local angle_vec = vector.new(pos.x, pos.y):normalized()
				local magnitude = (pos.x^2 + pos.y^2)^0.5

				if (magnitude + radius) > world.r then
					world:move_entity(entity, angle_vec * (world.r - radius))

					local norm_vel = vel:projectOn(angle_vec)
					local tangent_vel = vel - norm_vel
					entity.Velocity = tangent_vel - norm_vel

					world:emit_event("ArenaCollision", entity, angle_vec * world.r)
				end
			end
		},

		{
			name = "DestroyOutsideArena",
			requires = {"Position", "DestroyOutsideArena"},
			update = function(entity, world, dt)
				local tolerance = tonumber(entity.ArenaBounded) or -entity.Radius or 0
				if entity.Position.x < 0 - tolerance or entity.Position.x > world.w + tolerance
					or entity.Position.y < 0 - tolerance or entity.Position.y > world.h + tolerance
				then
					world:destroy_entity(entity)
				end
			end
		}
	},

	events = {
		{ -- Call arena collision functions of entities if they have them.
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				if entity.OnArenaCollision then
					entity:OnArenaCollision(world, pos, side)
				end
			end
		},
	}
}
