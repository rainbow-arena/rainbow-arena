local circle = require("util.circle")

---

local e_rocket = {}

---

function e_rocket.new(damage, radius, color)
	local rocket = {
		Radius = radius or 8,
		Color = color or {255, 255, 0},
		PhysicalDamage = damage,

		--CollisionPhysics = true,
		--IgnoreExplosion = true,

		DestroyOutsideArena = true,
		DieOnEntityCollision = true,

		DeathExplosion = {
			color = {255, 97, 0},
			radius = 150,
			force = 8^6,
			damage = 8,
			screenshake = 3,
			duration = 1
		},

		Rocket = true
	}

	rocket.Mass = circle.area(rocket.Radius)

	return rocket
end

---

return e_rocket
