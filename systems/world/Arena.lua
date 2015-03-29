local vector = require("lib.hump.vector")

---

return {
	systems = {
		{
			name = "ArenaCollision",
			requires = {"Position", "Velocity", "Radius", "ArenaBounded"},
			update = function(entity, world, dt)
				local pos, radius = entity.Position, entity.Radius
				local arena_w, arena_h = world.w, world.h

				-- Left
				if pos.x - radius < 0 then
					world:move_entity(entity, radius, entity.Position.y)
					entity.Velocity.x = -entity.Velocity.x

					world:emit_event("ArenaCollision", entity, vector.new(pos.x - radius, pos.y), "left")
				end

				-- Right
				if pos.x + radius > arena_w then
					world:move_entity(entity, arena_w - radius, entity.Position.y)
					entity.Velocity.x = -entity.Velocity.x

					world:emit_event("ArenaCollision", entity, vector.new(pos.x + radius, pos.y), "right")
				end

				-- Top
				if pos.y - radius < 0 then
					world:move_entity(entity, entity.Position.x, radius)
					entity.Velocity.y = -entity.Velocity.y

					world:emit_event("ArenaCollision", entity, vector.new(pos.x, pos.y - radius), "top")
				end

				-- Bottom
				if pos.y + radius > arena_h then
					world:move_entity(entity, entity.Position.x, arena_h - radius)
					entity.Velocity.y = -entity.Velocity.y

					world:emit_event("ArenaCollision", entity, vector.new(pos.x, pos.y + radius), "bottom")
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
