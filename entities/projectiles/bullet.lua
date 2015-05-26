local circle = require("util.circle")

---

local e_bullet = {}

---

function e_bullet.new(damage, radius, color)
	local bullet = {
		Radius = radius or 3,
		Color = color or {255, 255, 0},
		PhysicalDamage = damage,

		CollisionPhysics = true,
		IgnoreExplosion = true,

		DestroyOutsideArena = true,
		DieOnEntityCollision = true
	}

	bullet.Mass = circle.area(bullet.Radius)

	return bullet
end

---

return e_bullet
