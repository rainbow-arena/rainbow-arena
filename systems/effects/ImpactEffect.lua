local entity = require("util.entity")

---

return {
	events = {
		{ -- Knockback
			event = "EntityCollision",
			func = function(world, ent1, ent2, mtv)

			end
		},

		{ -- PhysicalDamage
			event = "EntityCollision",
			func = function(world, ent1, ent2, mtv)
				local projectile, target =
					entity.choosekey(ent1, ent2, "PhysicalDamage")

				if projectile and target.Health then
					target.Health = target.Health - projectile.PhysicalDamage
				end
			end
		}
	}
}
