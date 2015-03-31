local util = require("lib.self.util")

---

local math_sin = math.sin
local math_cos = math.cos

local math_clamp = util.math.clamp
local math_range = util.math.range
local math_map = util.math.map

---

local INTENSITY_DECAY_RATE = 2

local MIN_INTENSITY = 0.3
local MAX_INTENSITY = 0.7

local MAX_PULSE_SPEED = 500

---

local function calculate_single_entity_pulse(entity, velocity)
	return (velocity or entity.Velocity:len()) / MAX_PULSE_SPEED
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

---

return {
	systems = {
		{
			name = "DrawColoredCircle",
			requires = {"Position", "Radius", "Color"},
			draw = function(entity)
				local pos = entity.Position
				local radius = entity.Radius
				local color = entity.Color

				if not entity.ColorIntensity then
					entity.ColorIntensity = 0
				else
					entity.ColorIntensity = math_clamp(0, entity.ColorIntensity, 1)
				end

				local v = math_map(entity.ColorIntensity, 0, 1, MIN_INTENSITY, MAX_INTENSITY)

				---

				local fill_radius = radius
				if entity.Health and entity.MaxHealth then
					fill_radius = fill_radius * (math_clamp(0, entity.Health / entity.MaxHealth, 1))
				end
				love.graphics.setColor(color[1] * v, color[2] * v, color[3] * v)
				love.graphics.circle("fill", pos.x, pos.y, fill_radius)


				love.graphics.setStencil()
				love.graphics.setColor(color)
				love.graphics.circle("line", pos.x, pos.y, radius)
			end
		},

		{
			name = "DrawCircleRotation",
			requires = {"Position", "Radius", "Color", "Rotation"},
			priority = -1,
			draw = function(entity)
				local radius = entity.Radius
				local sx, sy = entity.Position:unpack()
				local ex, ey = sx + radius * math_cos(entity.Rotation),
					sy + radius * math_sin(entity.Rotation)

				love.graphics.setColor(entity.Color)
				love.graphics.line(sx,sy, ex,ey)
			end
		},

		{
			name = "RestoreCircleColor",
			requires = {"ColorIntensity"},
			update = function(entity, world, dt)
				local step = INTENSITY_DECAY_RATE*dt

				if math_range(-step, entity.ColorIntensity, step) then
					entity.ColorIntensity = 0
				elseif entity.ColorIntensity > 0 then
					entity.ColorIntensity = entity.ColorIntensity - step
				end
			end
		},

		{ -- Pulse the circle. Value is from 0 to 1.
			name = "PulseCircleColor",
			requires = {"ColorIntensity", "ColorPulse"},
			update = function(entity, world, dt)
				if entity.ColorIntensity < entity.ColorPulse then
					entity.ColorIntensity = entity.ColorPulse
				end

				entity.ColorPulse = nil
			end
		}
	},

	events = {
		{
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				entity.ColorPulse = calculate_single_entity_pulse(entity)
			end
		},
		{
			event = "PhysicsCollision",
			func = function(world, ent1, ent2, mtv)
				local res1, res2 = calculate_double_entity_pulse(ent1, ent2)

				ent1.ColorPulse = res1
				ent2.ColorPulse = res2
			end
		}
	}
}
