--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")

local circle = require("util.circle")
--- ==== ---


--- Class definition ---
local ent_Explosion = Class{}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function ent_Explosion:init(template)
	assert(util.table.check(template, {
		"Position",
		"radius",
		"duration"
	}, "ent_Explosion"))

	util.table.fill(template, {
		Color = {255, 97, 0}
	})

	util.table.fill(self, template)

	self.Blast = {
		radius = template.radius,
		duration = template.duration,
		func = function(e, impact, dir_vec)
			-- Pulse entity.
			if e.pulse then e:pulse(impact) end

			-- Apply explosion force.
			if e.Forces and not e.IgnoreExplosion then
				e.Forces[#e.Forces + 1] = {
					vector = impact * (template.force or 8 * 10^6) * dir_vec,
					duration = 0.1
				}
			end

			-- Apply health damage.
			if not e.IgnoreExplosion and e.Health and template.damage then
				e.Health.current = e.Health.current - math.ceil(impact * template.damage)
			end
		end
	}
end
--- ==== ---


return ent_Explosion
