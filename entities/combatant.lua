local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local circle = require("util.circle")

---

local table_fill = util.table.fill

---

local e_combatant = {}

function e_combatant.new(template)
	local radius = template.Radius or 30

	table_fill(template, {
		Velocity = vector.new(),

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

	return template
end

---

return e_combatant
