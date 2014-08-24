local intensity_rate = 1
local pulse_intensity = 0.75
local rest_intensity = 0.33

return {
	systems = {
		{
			name = "DrawCombatant",
			requires = {"Position", "Radius", "Color"},
			draw = function(entity)
				local pos = entity.Position
				local radius = entity.Radius
				local color = entity.Color

				if not entity.ColorIntensity then
					entity.ColorIntensity = 0.33
				end

				local v = entity.ColorIntensity

				love.graphics.setColor(color[1] * v, color[2] * v, color[3] * v)
				love.graphics.circle("fill", pos.x, pos.y, radius, 20)

				love.graphics.setColor(color)
				love.graphics.circle("line", pos.x, pos.y, radius, 20)
			end
		},

		{
			name = "RestoreCombatantColor",
			requires = {"ColorIntensity"},
			update = function(entity, world, dt)
				local rate = entity.ColorRate or intensity_rate
				local rest = entity.RestIntensity or rest_intensity

				if entity.ColorIntensity < rest then
					entity.ColorIntensity = entity.ColorIntensity + rate*dt
				elseif entity.ColorIntensity > rest then
					entity.ColorIntensity = entity.ColorIntensity - rate*dt
				end
			end
		}
	},

	events = {
		{ -- Entity color flashes.
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				entity.ColorIntensity = entity.PulseIntensity or pulse_intensity
			end
		},
		{
			event = "EntityCollision",
			func = function(world, ent1, ent2, mtv)
				ent1.ColorIntensity = ent1.PulseIntensity or pulse_intensity
				ent2.ColorIntensity = ent2.PulseIntensity or pulse_intensity
			end
		},
		{
			event = "WeaponFired",
			func = function(world, entity)
				entity.ColorIntensity = entity.PulseIntensity or pulse_intensity
			end
		},
	}
}
