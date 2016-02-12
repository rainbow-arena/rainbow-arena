--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")
--- ==== ---


--- System definition ---
local Motion = tiny.processingSystem()
Motion.filter = tiny.requireAll("Position", "Velocity")
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function Motion:process(e, dt)
	local world = self.world.world

	--- Apply Velocity to Position.
	world:move_entity(e, e.Position + e.Velocity * dt)


	--- Apply Acceleration to Velocity.
	if e.Acceleration then
		e.Velocity = e.Velocity + (e.Acceleration * e.Velocity) * dt
	end
end
--- ==== ---

return Class(Motion)
