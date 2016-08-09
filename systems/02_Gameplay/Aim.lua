--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


-- TODO: Have AimVector be speed-limited like AimAngle, and base AimAngle
-- solely on this?


--- System ---
local sys_Aim = Class(tiny.processingSystem())
sys_Aim.filter = tiny.requireAll("AimVector", "AimAngle", "AimSpeed")
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Aim:process(e, dt)
	local current = e.AimAngle
	local target = math.atan2(e.AimVector.y, e.AimVector.x)

	local vec = math.atan2(
		math.sin(target - current),
		math.cos(target - current)
	)

	local dir = util.math.sign(vec)
	local dist = math.abs(vec)

	---

	-- When AimAngle is within GUARD_DIST of the target angle, the effective
	-- AimSpeed is slowed linearly, to smooth the aim movement as it reaches the
	-- target.

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

return sys_Aim
