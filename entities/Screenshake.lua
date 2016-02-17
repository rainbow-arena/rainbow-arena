--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")
--- ==== ---


--- Classes ---
--- ==== ---


--- Class definition ---
local ent_Screenshake = {}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function ent_Screenshake:init(template)
	assert(util.table.check(template, {
		"Position",
		"radius",
		"intensity"
	}, "Screenshake"))

	util.table.fill(self, template)

	self.Screenshake = {
		radius = template.radius,
		intensity = template.intensity,
		duration = template.duration,
		removeOnFinish = template.removeOnFinish
	}
end
--- ==== ---


return Class(ent_Screenshake)
