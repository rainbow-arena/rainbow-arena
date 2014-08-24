local util = require("lib.self.util")

local clamp = util.math.clamp
local range = util.math.range

local intensity_rate = 1.5
local max_intensity = 0.8
local pulse_intensity = 0.75
local rest_intensity = 0.33
local max_pulse_speed = 500
local rest_tolerance = 0.04

local function calculate_single_entity_pulse(entity, velocity)
	return (entity.RestIntensity or rest_intensity)
		+ (entity.PulseIntensity or pulse_intensity)
		* ((velocity or entity.Velocity:len()) / max_pulse_speed)
end

local function calculate_double_entity_pulse(ent1, ent2)
	local diff = ent2.Position - ent1.Position

	local v1 = ent1.Velocity:projectOn(diff)
	local v2 = ent2.Velocity:projectOn(diff)

	local vf = (v1 + v2):len()

	local res1 = calculate_single_entity_pulse(ent1, vf)
	local res2 = calculate_single_entity_pulse(ent2, vf)

	return res1, res2
end

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

				entity.ColorIntensity = clamp(0, entity.ColorIntensity, entity.MaxIntensity or max_intensity)
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

				if range(rest - rest_tolerance, entity.ColorIntensity, rest + rest_tolerance) then
					entity.ColorIntensity = rest
				elseif entity.ColorIntensity < rest then
					entity.ColorIntensity = entity.ColorIntensity + rate*dt
				elseif entity.ColorIntensity > rest then
					entity.ColorIntensity = entity.ColorIntensity - rate*dt
				end
			end
		}
	},

	events = {
		{
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				local res = calculate_single_entity_pulse(entity)

				if entity.ColorIntensity < res then
					entity.ColorIntensity = res
				end
			end
		},
		{
			event = "PhysicsCollision",
			func = function(world, ent1, ent2, mtv)
				local res1, res2 = calculate_double_entity_pulse(ent1, ent2)

				if ent1.ColorIntensity < res1 then
					ent1.ColorIntensity = res1
				end
				if ent2.ColorIntensity < res2 then
					ent2.ColorIntensity = res2
				end
			end
		},
		{
			event = "ProjectileCollision",
			func = function(world, projectile, target, mtv)
				target.ColorIntensity = target.PulseIntensity or pulse_intensity
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
