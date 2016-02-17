--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- System ---
local sys_Screenshake = Class(tiny.processingSystem())
sys_Screenshake.filter = tiny.requireAll("Position", "Screenshake")
--- ==== ---


--- Local functions ---
local function draw_entity_debug_info(e)
	local str_t = {}

	---

	--str_t[#str_t + 1] = (""):format()

	if e.Name then
		str_t[#str_t + 1] = ("Name: %s"):format(e.Name)
	end

	str_t[#str_t + 1] = ("Position: (%.2f, %.2f)"):format(e.Position.x, e.Position.y)

	str_t[#str_t + 1] = ("Screenshake radius: %.2f"):format(e.Screenshake.radius)
	str_t[#str_t + 1] = ("Screenshake intensity: %.2f)"):format(e.Screenshake.intensity)

	---

	local str = table.concat(str_t, "\n")

	local text_w = love.graphics.getFont():getWidth(str)

	local x = e.Position.x - text_w/2
	local y = e.Position.y + 10

	love.graphics.setColor(255, 255, 255)
	love.graphics.print(str, math.floor(x), math.floor(y))
end
--- ==== ---


--- System functions ---
function sys_Screenshake:preProcess()
	local world = self.world.world

	world.camera.screenshake = 0
end

function sys_Screenshake:process(e, dt)
	local world = self.world.world

	---

	local screenshake = e.Screenshake
	assert(util.table.check(screenshake, {
		"intensity",
		"radius"
	}), "Screenshake component")

	-- Initialise starting time if this is a timed source.
	if not screenshake.timer and screenshake.duration then
		screenshake.timer = screenshake.duration
	end

	-- Step screenshake timer.
	if screenshake.timer then
		screenshake.timer = screenshake.timer - dt
		if screenshake.timer <= 0 then
			if screenshake.removeOnFinish then
				world:remove_entity(e)
				return
			end
		end
	end

	local intensity = screenshake.intensity
	if screenshake.timer and screenshake.duration then -- Adjust timed source intensity.
		intensity = intensity * (screenshake.timer / screenshake.duration)
	end

	local camera_pos = vector.new(world.camera.x, world.camera.y)
	local dist_to_source = (e.Position - camera_pos):len()

	local final_intensity = util.math.clamp(0, intensity * (1 - (dist_to_source/screenshake.radius)), math.huge)

	world.camera.screenshake = world.camera.screenshake + final_intensity

	---

	if world.DEBUG then
		draw_entity_debug_info(e)
	end
end
--- ==== ---

return sys_Screenshake
