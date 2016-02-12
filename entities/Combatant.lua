--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")

local circle = require("util.circle")
--- ==== ---


--- Class definition ---
local ent_Combatant = {}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function ent_Combatant:init(template)
	assert(util.table.check(template, {"Position"}))

	local radius = template.Radius or 30

	util.table.fill(template, {
		Velocity = vector.new(),
		Acceleration = vector.new(),
		Force = vector.new(),

		Radius = radius,
		Mass = circle.area(radius),
		Color = {255, 255, 255},

		AimAngle = 0,
		DesiredAimAngle = 0,
		AimSpeed = 4,

		Health = 30,
		MaxHealth = 30,

		ExplodeOnDeath = true
	})

	util.table.fill(self, template)
end
--- ==== ---


return Class(ent_Combatant)
