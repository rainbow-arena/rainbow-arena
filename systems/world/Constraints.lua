local vector = require("lib.hump.vector")

return {
	systems = {
		{
			name = "UpdateAttachedEntity",
			requires = {"Position", "AttachedTo"},
			update = function(entity, world, dt)
				if world.entities[entity.AttachedTo] then
					entity.Position = entity.AttachedTo.Position:clone()
						+ (entity.AttachmentOffset or vector.zero)
					if entity.AttachedTo.Velocity then
						entity.Velocity = entity.AttachedTo.Velocity:clone()
					else
						entity.Velocity = vector.new(0, 0)
					end
				else
					entity.AttachedTo = nil
				end
			end
		}
	}
}
