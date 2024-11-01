--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")

local circle = require("util.circle")
--- ==== ---

--- System ---
local sys_DrawPhysical = Class(tiny.processingSystem())
sys_DrawPhysical.filter = tiny.requireAll("Position", "Radius", "Color")
--- ==== ---

--- Constants ---
local COLOR_INTENSITY_DECAY_RATE = 2

local MIN_COLOR_INTENSITY = 0.3
local MAX_COLOR_INTENSITY = 0.7
--- ==== ---

--- Local functions ---
local function draw_entity_circle(e)
	local pos = e.Position
	local radius = e.Radius
	local color = e.Color

	if not e.ColorIntensity then
		e.ColorIntensity = 0
	else
		e.ColorIntensity = util.math.clamp(0, e.ColorIntensity, 1)
	end

	local amp = util.math.map(e.ColorIntensity, 0, 1, MIN_COLOR_INTENSITY, MAX_COLOR_INTENSITY)

	---

	-- Fill radius is based on health.
	local fill_radius = radius
	if e.Health then
		fill_radius = fill_radius * (util.math.clamp(0, e.Health.current / e.Health.max, 1))
	end
	love.graphics.setColor(color[1] * amp, color[2] * amp, color[3] * amp)
	love.graphics.circle("fill", pos.x, pos.y, fill_radius)

	love.graphics.setColor(color)
	love.graphics.circle("line", pos.x, pos.y, radius)
end

local function draw_entity_aiming(e)
	local radius = e.Radius
	local sx, sy = e.Position:unpack()
	local angle = e.AimAngle
	local ex, ey = sx + radius * math.cos(angle), sy + radius * math.sin(angle)

	love.graphics.setColor(e.Color)
	love.graphics.line(sx, sy, ex, ey)
end

local function draw_entity_debug_info(e)
	local str_t = {}

	---

	--str_t[#str_t + 1] = (""):format()

	if e.Name then
		str_t[#str_t + 1] = ("Name: %s"):format(e.Name)
	end

	str_t[#str_t + 1] = ("Position: (%.2f, %.2f)"):format(e.Position.x, e.Position.y)

	if e.Mass then
		str_t[#str_t + 1] = ("Mass: %.2f"):format(e.Mass)
	end

	if e.Velocity then
		str_t[#str_t + 1] = ("Velocity: (%.2f, %.2f)"):format(e.Velocity.x, e.Velocity.y)
	end

	if e.Acceleration then
		str_t[#str_t + 1] = ("Accel: (%.2f, %.2f)"):format(e.Acceleration.x, e.Acceleration.y)
	end

	if e.Health then
		str_t[#str_t + 1] = ("Health: %d/%d"):format(e.Health.current, e.Health.max)
	end

	---

	local str = table.concat(str_t, "\n")

	local text_w = love.graphics.getFont():getWidth(str)

	local x = e.Position.x - text_w / 2
	local y = e.Position.y + e.Radius + 10

	love.graphics.setColor(1, 1, 1)
	love.graphics.print(str, math.floor(x), math.floor(y))
end

---

local function restore_color_amp(e, dt)
	local step = COLOR_INTENSITY_DECAY_RATE * dt

	if e.ColorIntensity < step then
		e.ColorIntensity = 0
	elseif e.ColorIntensity > 0 then
		e.ColorIntensity = e.ColorIntensity - step
	end
end
--- ==== ---

--- System functions ---
function sys_DrawPhysical:process(e, dt)
	local world = self.world.world

	draw_entity_circle(e)

	if e.AimAngle then
		draw_entity_aiming(e)
	end

	restore_color_amp(e, dt)

	if world.DEBUG then
		draw_entity_debug_info(e)
	end
end
--- ==== ---

return sys_DrawPhysical
