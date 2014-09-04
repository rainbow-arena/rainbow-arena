local vector = require("lib.hump.vector")

return {
	systems = {
		{
			name = "UpdateAttachedEntity",
			requires = {"Position", "AttachedTo"},
			update = function(entity, world, dt)
				entity.Position = entity.AttachedTo.Position:clone()
					+ (entity.AttachmentOffset or vector.zero)
			end
		}
	}
}
