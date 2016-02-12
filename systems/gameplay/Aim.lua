--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- System definition ---
local sys_Aim = tiny.processingSystem()
sys_Aim.filter = tiny.requireAll("AimAngle", "DesiredAimAngle", "AimSpeed")
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Aim:process(e, dt)
	local current = e.AimAngle
	local target = e.DesiredAimAngle

	local vec = math.atan2(
		math.sin(target - current),
		math.cos(target - current)
	)

	local dir = util.math.sign(vec)
	local dist = math.abs(vec)

	---

	local GUARD_DIST = math.pi/6
	local step = (dist / GUARD_DIST) * e.AimSpeed * dt

	local new
	if dist < step then
		new = target
	else
		new = current + dir * step
	end

	e.AimAngle = new
end
--- ==== ---

return Class(sys_Aim)
