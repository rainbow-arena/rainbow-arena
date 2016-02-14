--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- System definition ---
local sys_Motion = tiny.processingSystem()
sys_Motion.filter = tiny.requireAll("Position", "Velocity", "Acceleration", "Force", "Forces", "Mass")
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Motion:process(e, dt)
	local world = self.world.world

	-- Add drag force.
	--e.Forces[#e.Forces + 1] = (e.Drag * -e.Velocity)

	-- Aggregate all forces applied this frame.
	-- TODO: Give each force a duration, as current code relies on dt being constant each frame.
	for i, force in ipairs(e.Forces) do
		assert(vector.isvector(force.vector), "ERROR: e.Forces[x].vector must be a vector!")

		if not force.duration then
			-- Apply force for one frame only.
			e.Force = e.Force + force.vector
			table.remove(e.Forces, i)
		elseif force.duration < dt then
			-- Force has less than dt duration left.
			e.Force = e.Force + force.vector * util.math.clamp(0, force.duration/dt, math.huge)
			table.remove(e.Forces, i)
		else
			-- Force has more than dt duration left.
			e.Force = e.Force + force.vector
			force.duration = force.duration - dt
		end
	end

	-- Convert Force into Acceleration.
	e.Acceleration = e.Force / e.Mass

	-- Apply Acceleration (and Drag) to Velocity.
	e.Velocity = e.Velocity + (e.Acceleration - (e.Drag or 0) * e.Velocity) * dt

	-- Apply Velocity to Position.
	world:move_entity(e, e.Position + e.Velocity * dt)

	-- Reset Force
	e.Force = vector.new(0, 0)
end
--- ==== ---

return Class(sys_Motion)
