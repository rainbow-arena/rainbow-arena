local vector = require("lib.hump.vector")
local util = require("lib.self.util")

---

local sin, cos = math.sin, math.cos

---

return {
	systems = {
		{
			name = "UpdateRotation",
			requires = {"Rotation", "RotationTarget", "RotationSpeed"},
			update = function(entity, world, dt)
				--local current = vector.new(cos(entity.Rotation), sin(entity.Rotation))
				--local target = vector.new(cos(entity.Rotation), sin(entity.Rotation))

				entity.Rotation = entity.RotationTarget
			end
		}
	}
}
