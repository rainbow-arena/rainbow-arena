--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- System ---
local sys_Motion = tiny.processingSystem()
sys_Motion.filter = tiny.requireAll("Position", "Velocity", "Acceleration", "Force", "Forces", "Mass")
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Motion:process(e, dt)
	local world = self.world.world

	-- Add drag force.
	e.Forces[#e.Forces + 1] = {
		vector = e.Drag * -e.Velocity
	}

	---

	--- Aggregate all forces applied this frame.
	-- Reset Force
	e.Force = vector.new(0, 0)

	-- Sum the forces and remove as needed.
	local i = 1
	while i <= #e.Forces do
		local force = e.Forces[i]

		assert(vector.isvector(force.vector), "ERROR: e.Forces[x].vector must be a vector!")

		local remove_force = false

		if not force.duration then
			-- Apply force for one frame only.
			e.Force = e.Force + force.vector * dt
			remove_force = true
		elseif force.duration < dt then
			-- Force has less than dt duration left.
			e.Force = e.Force + force.vector * force.duration/dt
			remove_force = true
		else
			-- Force has more than dt duration left.
			e.Force = e.Force + force.vector
			force.duration = force.duration - dt
		end

		if remove_force then
			table.remove(e.Forces, i)
		else
			i = i + 1
		end
	end

	---

	-- Convert Force into Acceleration.
	e.Acceleration = e.Force / e.Mass

	-- Apply Acceleration (and Drag) to Velocity.
	e.Velocity = e.Velocity + e.Acceleration * dt

	-- Apply Velocity to Position.
	world:move_entity(e, e.Position + e.Velocity * dt)
end
--- ==== ---

return Class(sys_Motion)
