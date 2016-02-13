--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")
--- ==== ---


--- System definition ---
local sys_Motion = tiny.processingSystem()
sys_Motion.filter = tiny.requireAll("Position", "Velocity", "Acceleration", "Force", "Forces", "Mass")
--- ==== ---


--- Local functions ---
--- ==== ---

-- entity.Velocity = entity.Velocity + ((entity.Acceleration or vector.zero) - (entity.Drag or 0) * entity.Velocity)*dt

--- System functions ---
function sys_Motion:process(e, dt)
	local world = self.world.world

	-- Add drag force.
	--e.Forces[#e.Forces + 1] = (e.Drag * -e.Velocity)

	-- Aggregate all forces applied this frame.
	for _, force in ipairs(e.Forces) do
		assert(vector.isvector(force), "e.Forces[x] must be a vector!")
		e.Force = e.Force + force
	end

	-- Convert Force into Acceleration.
	e.Acceleration = e.Force / e.Mass

	-- Apply Acceleration (and Drag) to Velocity.
	e.Velocity = e.Velocity + (e.Acceleration - (e.Drag or 0) * e.Velocity) * dt

	-- Apply Velocity to Position.
	world:move_entity(e, e.Position + e.Velocity * dt)

	-- Reset Force(s)
	e.Force = vector.new(0, 0)
	e.Forces = {}
end
--- ==== ---

return Class(sys_Motion)
