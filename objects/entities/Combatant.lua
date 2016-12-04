--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")

local circle = require("util.circle")
--- ==== ---


--- Classes ---
local ent_Physical = require("objects.entities.Physical")
--- ==== ---


--- Class definition ---
local ent_Combatant = Class{__includes = ent_Physical}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function ent_Combatant:init(template)
	local radius = math.floor(template.Radius or 30)
	local health = radius^2

	util.table.fill(template, {
		AimVector = vector.new(0, 0),

		AimAngle = 0,
		AimSpeed = 4, -- Radians per second (I think).

		ColorIntensity = 0,

		Health = {max = health, current = health},

		ExplodeOnDeath = true
	})

	util.table.fill(self, template)

	return ent_Physical.init(self, template)
end

function ent_Combatant:pulse(amp)
	self.ColorIntensity = util.math.clamp(0, self.ColorIntensity + amp, 1)
end
--- ==== ---


return ent_Combatant
