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
	assert(util.table.check(template, {
		"Position"
	}, "Combatant"))

	local radius = math.floor(template.Radius or 30)
	local health = radius^2

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

		ColorIntensity = 0,

		Health = {max = health, current = health},

		ExplodeOnDeath = true
	})

	util.table.fill(self, template)
end

function ent_Combatant:pulse(amp)
	self.ColorIntensity = util.math.clamp(0, self.ColorIntensity + amp, 1)
end
--- ==== ---


return Class(ent_Combatant)
