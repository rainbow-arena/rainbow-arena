local vector = require("lib.hump.vector")
local util = require("lib.self.util")

---

local table_has = util.table.has

---

local __TRUE__ = function() return true end

---

return {
	systems = {
		{
			name = "UpdateWeapon",
			requires = {"Position", "Radius", "Rotation", "Weapon"},
			update = function(entity, world, dt)
				local weapon = entity.Weapon

				if weapon.Firing then
					if not weapon._Firing then
						weapon._Firing = true
						(weapon.fire or __TRUE__)(weapon, entity, world)
					else
						(weapon.firing or __TRUE__)(weapon, entity, world, dt)
					end
				else
					if weapon._Firing then
						weapon._Firing = false
						(weapon.cease or __TRUE__)(weapon, entity, world)
					end
				end

				(weapon.update or __TRUE__)(weapon, entity, world, dt)
			end
		}
	},

	events = {

	}
}
