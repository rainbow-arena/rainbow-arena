--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")
--- ==== ---


--- System definition ---
local sys_Motion = tiny.processingSystem()
sys_Motion.filter = tiny.requireAll("Position", "Velocity")
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Motion:process(e, dt)
	local world = self.world.world

	-- Convert Force into Acceleration.
	if e.Force then
		e.Acceleration = e.Force / e.Mass
	end

	-- Apply Acceleration to Velocity.
	if e.Acceleration then
		e.Velocity = e.Velocity + e.Acceleration * dt
	end

	-- Apply Velocity to Position.
	world:move_entity(e, e.Position + e.Velocity * dt)
end
--- ==== ---

return Class(sys_Motion)
