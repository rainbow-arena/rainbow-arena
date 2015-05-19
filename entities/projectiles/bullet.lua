local circle = require("util.circle")

---

local e_bullet = {}

---

function e_bullet.new(damage, radius, color)
	local bullet = {
		Radius = radius or 3,
		Color = color or {0, 200, 200},
		PhysicalDamage = damage,

		CollisionPhysics = true,

		DestroyOutsideArena = true,
		DestroyOnEntityCollision = true
	}

	bullet.Mass = circle.area(bullet.Radius)

	return bullet
end

---

return e_bullet
