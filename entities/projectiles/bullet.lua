local e_bullet = {}

---

function e_bullet.new(damage, radius, color)
	return {
		Radius = radius or 2,
		Color = color or {0, 200, 200},
		PhysicalDamage = damage
	}
end

---

return e_bullet
