--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")

local circle = require("util.circle")
--- ==== ---


--- Class definition ---
local ent_Physical = {}
--- ==== ---


--- Local functions ---
-- https://stackoverflow.com/questions/667034/simple-physics-based-movement
local function calculate_drag_accel(max_speed, accel_time)
	local drag = 5/accel_time -- drag = 5/t_max
	local accel = max_speed * drag -- acc = v_max * drag
	return drag, accel
end

local default_drag, default_accel = calculate_drag_accel(800, 5)
--- ==== ---


--- Class functions ---
function ent_Physical:init(template)
	assert(util.table.check(template, {
		"Position"
	}, "Physical"))

	local radius = math.floor(template.Radius or 30)
	local mass = circle.area(radius)

	util.table.fill(template, {
		Velocity = vector.new(),
		Acceleration = vector.new(),
		Force = vector.new(),
		Forces = {},

		MoveForce = 2261947, -- = default_accel [800] * circle.area(30) [mass of radius 30 physicaly]
		Drag = default_drag,

		Radius = radius,
		Mass = mass,
		Color = {255, 255, 255}
	})

	util.table.fill(self, template)
end
--- ==== ---


return Class(ent_Physical)
