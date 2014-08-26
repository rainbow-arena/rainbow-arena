local vector = require("lib.hump.vector")

return {
	systems = {
		{
			name = "UpdateWeapon",
			requires = {"Weapon"},
			update = function(entity, world, dt)
				if entity.Firing then
					local direction_vector = vector.new(
							math.cos(entity.Rotation), math.sin(entity.Rotation))
					local position_vector = entity.Position:clone()
						+ (direction_vector * (entity.Radius))

					-- fire_start: called first when the weapon starts firing.
					if not entity.Weapon.fired then
						entity.Weapon:fire_start(entity, world, position_vector, direction_vector)
						entity.Weapon.firing = true
					end

					-- fire_update: called every frame while firing.
					if entity.Weapon.fire_update then
						entity.Weapon:fire_update(entity, world, dt, position_vector, direction_vector)
					end

				elseif entity.Weapon.firing then
					-- fire_end: called when the weapon ceases firing.
					if entity.Weapon.fire_end then
						entity.Weapon:fire_end(entity, world)
					end
					entity.Weapon.firing = false
				end
			end
		}
	},

	events = {

	}
}
