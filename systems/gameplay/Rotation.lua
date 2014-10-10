local vector = require("lib.hump.vector")
local util = require("lib.self.util")

---

local pi = math.pi
local sin, cos = math.sin, math.cos
local atan2 = math.atan2
local abs = math.abs
local sign = util.math.sign
local floor = math.floor

---

return {
	systems = {
		{
			name = "UpdateRotation",
			requires = {"Rotation", "RotationTarget", "RotationSpeed"},
			update = function(entity, world, dt)
				local current = entity.Rotation
				local target = entity.RotationTarget

				local vec = atan2(
					sin(target - current),
					cos(target - current)
				)

				local dir = sign(vec)
				local dist = abs(vec)

				---

				local GUARD_DIST = pi/6
				local step = (dist / GUARD_DIST) * entity.RotationSpeed * dt

				local new
				if dist < step then
					new = target
				else
					new = entity.Rotation + dir * step
				end

				entity.Rotation = new
			end
		}
	}
}
