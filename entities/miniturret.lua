local class = require("lib.hump.class")

---

local e_combatant = require("entities.combatant")
local e_miniturret = class{__includes = e_combatant}

---

function e_miniturret:init(arg)
	self.DumbTurretAI = true
	self.TargetSearchRadius = arg.target_search_radius or 10000

	arg.radius = arg.radius or 15

	e_combatant.init(self, arg)
end

---

return e_miniturret
