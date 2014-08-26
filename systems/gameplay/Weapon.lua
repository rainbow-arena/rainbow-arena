local vector = require("lib.hump.vector")

return {
	systems = {
		{
			name = "UpdateWeapon",
			requires = {"Weapon"},
			update = function(entity, world, dt)
				local weapon = entity.Weapon

				if entity.Firing then
					if weapon.heat >= weapon.max_heat then
						weapon.overheat = true
					end

					if not weapon.overheat then
						local direction_vector = vector.new(
							math.cos(entity.Rotation), math.sin(entity.Rotation))
						local position_vector = entity.Position:clone()
							+ (direction_vector * (entity.Radius))

						-- fire_start: called first when the weapon starts firing.
						if not weapon._fired then
							weapon:start(entity, world, position_vector, direction_vector)
							weapon._fired = true
						end

						-- fire_update: called every frame while firing.
						if weapon.update then
							weapon:update(dt, entity, world, position_vector, direction_vector)
						end
					end

				else -- if not entity.Firing then
					if weapon.fired then
						-- fire_end: called when the weapon ceases firing.
						if weapon.cease then
							weapon:cease(entity, world)
						end
						weapon._fired = false
					end

					weapon.heat = weapon.heat - dt
					if weapon.heat < 0 then
						weapon.overheat = false
						weapon.heat = 0
					end
				end
			end
		}
	},

	events = {

	}
}
