local vector = require("lib.hump.vector")

return {
	systems = {
		{
			name = "UpdateWeapon",
			requires = {"Weapon"},
			update = function(entity, world, dt)
				-- Cooldown.
				if not entity.Weapon.heat then entity.Weapon.heat = 0 end
				entity.Weapon.heat = entity.Weapon.heat - dt
				if entity.Weapon.heat < 0 then entity.Weapon.heat = 0 end

				-- Reset "fired" flag.
				if entity.Weapon.fired and not entity.Firing then
					if entity.Weapon.fire_end then
						entity.Weapon:fire_end(entity, world)
					end
					entity.Weapon.fired = false
				end

				if entity.Firing then
					local direction_vector = vector.new(
							math.cos(entity.Rotation), math.sin(entity.Rotation))
					local position_vector = entity.Position:clone()
						+ (direction_vector * (entity.Radius))

					-- Fire if applicable.
					if entity.Weapon.heat == 0 then
						if (entity.Weapon.type == "single" and not entity.Weapon.fired)
							or entity.Weapon.type == "repeat"
						then
							world:emitEvent("WeaponFired", entity, position_vector, direction_vector)
							entity.Weapon:fire(world, entity, position_vector, direction_vector)
							entity.Weapon.fired = true
						end
					end

					-- Called every frame while firing or after fired. Useful for beam weapons.
					if entity.Weapon.firing then
						entity.Weapon:firing(entity, world, dt, position_vector, direction_vector)
					end
				end
			end
		}
	},

	events = {

	}
}
