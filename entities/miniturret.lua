local e_combatant = require("entities.combatant")

---

local e_miniturret = {}

---

function e_miniturret.new(template)
	table_fill(template, {
		Radius = 15,
		TargetSearchRadius = 200,

		DumbTurretAI = true
	})

	return e_combatant.new(template)
end

---

return e_miniturret
