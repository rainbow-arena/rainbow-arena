local util = require("lib.self.util")

local clamp = util.math.clamp

local intensity_rate = 1
local max_intensity = 0.9
local pulse_intensity = 0.75
local rest_intensity = 0.33
local max_pulse_speed = 700

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

				local v = clamp(0, entity.ColorIntensity, entity.MaxIntensity or max_intensity)

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
				local res = (entity.RestIntensity or rest_intensity)
					+ (entity.PulseIntensity or pulse_intensity)
					* (entity.Velocity:len() / max_pulse_speed)

				if entity.ColorIntensity < res then
					entity.ColorIntensity = res
				end
			end
		},
		{
			event = "EntityCollision",
			func = function(world, ent1, ent2, mtv)
				local diff = ent2.Position - ent1.Position

				local v1 = ent1.Velocity:projectOn(diff)
				local v2 = ent2.Velocity:projectOn(diff)

				local mult = (v1 + v2):len() / (max_pulse_speed)

				local res1 = (ent1.RestIntensity or rest_intensity)
					+ (ent1.PulseIntensity or pulse_intensity) * mult
				local res2 = (ent2.RestIntensity or rest_intensity)
					+ (ent2.PulseIntensity or pulse_intensity) * mult

				if ent1.ColorIntensity < res1 then
					ent1.ColorIntensity = res1
				end
				if ent2.ColorIntensity < res2 then
					ent2.ColorIntensity = res2
				end
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
