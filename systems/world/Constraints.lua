local vector = require("lib.hump.vector")

return {
	systems = {
		{
			name = "UpdateChild",
			requires = {"Position", "Parent"},
			update = function(entity, world, dt)
				if world.entities[entity.Parent] then
					entity.Position = entity.Parent.Position:clone()
						+ (entity.AttachmentOffset or vector.zero)
					if entity.Parent.Velocity then
						entity.Velocity = entity.Parent.Velocity:clone()
					else
						entity.Velocity = vector.new(0, 0)
					end
				elseif entity.DestroyWithParent then
					world:destroy_entity(entity)
				else
					entity.Parent = nil
				end
			end
		},

		{
			name = "DestroyAfterLifetime",
			requires = {"Lifetime"},
			update = function(entity, world, dt)
				entity.Lifetime = entity.Lifetime - dt

				if entity.Lifetime <= 0 then
					world:destroy_entity(entity)
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
	}
}
