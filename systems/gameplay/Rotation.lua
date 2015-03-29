local vector = require("lib.hump.vector")
local util = require("lib.self.util")

---

local math_pi = math.pi

local math_sin = math.sin
local math_cos = math.cos
local math_atan2 = math.atan2

local math_abs = math.abs
local math_sign = util.math.sign

---

return {
	systems = {
		{
			name = "UpdateRotation",
			requires = {"Rotation", "RotationTarget", "RotationSpeed"},
			update = function(entity, world, dt)
				local current = entity.Rotation
				local target = entity.RotationTarget

				local vec = math_atan2(
					math_sin(target - current),
					math_cos(target - current)
				)

				local dir = math_sign(vec)
				local dist = math_abs(vec)

				---

				local GUARD_DIST = math_pi/6
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
