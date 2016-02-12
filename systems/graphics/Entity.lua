--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")

local circle = require("util.circle")
--- ==== ---


--- System definition ---
local DrawEntity = tiny.processingSystem()
DrawEntity.filter = tiny.requireAll("Position", "Radius", "Color")

DrawEntity.isDrawSystem = true
--- ==== ---


--- Constants ---
local INTENSITY_DECAY_RATE = 2

local MIN_INTENSITY = 0.3
local MAX_INTENSITY = 0.7

local MAX_PULSE_SPEED = 500
--- ==== ---


--- Local functions ---
local function calculate_single_entity_pulse(e, velocity)
	return (velocity or e.Velocity:len()) / MAX_PULSE_SPEED
end

local function calculate_double_entity_pulse(e1, e2)
	local diff = e1.Position - e2.Position

	local v1 = e1.Velocity:projectOn(diff)
	local v2 = e2.Velocity:projectOn(diff)

	local vf = (v1 + v2):len()

	local res1 = calculate_single_entity_pulse(e1, vf)
	local res2 = calculate_single_entity_pulse(e2, vf)

	return res1, res2
end

---

local function draw_entity_circle(e)
	local pos = e.Position
	local radius = e.Radius
	local color = e.Color

	if not e.ColorIntensity then
		e.ColorIntensity = 0
	else
		e.ColorIntensity = math_clamp(0, e.ColorIntensity, 1)
	end

	local amp = util.math.map(e.ColorIntensity, 0,1, MIN_INTENSITY,MAX_INTENSITY)

	---

	-- Fill radius is based on health.
	local fill_radius = radius
	if e.Health and e.MaxHealth then
		fill_radius = fill_radius * (math_clamp(0, e.Health / e.MaxHealth, 1))
	end
	love.graphics.setColor(color[1] * amp, color[2] * amp, color[3] * amp)
	love.graphics.circle("fill", pos.x, pos.y, fill_radius)


	love.graphics.setStencil()
	love.graphics.setColor(color)
	love.graphics.circle("line", pos.x, pos.y, radius)
end

local function draw_entity_aiming(e)
	local radius = e.Radius
	local sx, sy = e.Position:unpack()
	local angle = e.AimAngle
	local ex, ey = sx + radius * math_cos(angle), sy + radius * math_sin(angle)

	love.graphics.setColor(e.Color)
	love.graphics.line(sx,sy, ex,ey)
end

---

local function restore_color_amp(e, dt)
	local step = INTENSITY_DECAY_RATE*dt

	if entity.ColorIntensity < step then
		entity.ColorIntensity = 0
	elseif entity.ColorIntensity > 0 then
		entity.ColorIntensity = entity.ColorIntensity - step
	end
end
--- ==== ---


--- System functions ---
function DrawEntity:onAddToWorld(world)
	local world = world.world

	-- Combatants blink upon hitting eachother.
	world:register_event("PhysicsCollision", function(world, e1, e2, mtv)
		local v1, v2 = calculate_double_entity_pulse(e1, e2)

		e1.ColorIntensity = v1
		e2.ColorIntensity = v2
	end)
end

function DrawEntity:process(e, dt)
	draw_entity_circle(e)

	if e.AimAngle then
		draw_entity_aiming(e)
	end

	restore_color_amp(e, dt)
end
--- ==== ---

return Class(DrawEntity)
