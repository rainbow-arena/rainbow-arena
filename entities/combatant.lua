local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local circle = require("util.circle")

---

local table_fill = util.table.fill

---

-- TODO: Allow passing raw template, defaults are filled and others are not touched.
-- .new() function, nest these for miniturret.

local e_combatant = {}

function e_combatant.new(template)
	local radius = template.Radius or 30

	table_fill(template, {
		Radius = radius,
		Mass = circle.area(radius),
		Color = {255, 255, 255},

		CollisionPhysics = true,
		ArenaBounded = true,

		Rotation = 0,
		RotationSpeed = 4,

		Health = radius,
		MaxHealth = radius,

		DeathExplosion = true
	})

	if template.Player then
		template.CameraTarget = true
	end

	return template
end

---

return e_combatant
