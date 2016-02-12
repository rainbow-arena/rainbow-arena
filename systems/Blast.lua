--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local circle = require("util.circle")
--- ==== ---


--- System definition ---
local sys_Blast = tiny.processingSystem()
sys_Blast.filter = tiny.requireAll("Position", "Blast")

sys_Blast.isDrawSystem = true
--- ==== ---


--- Constants ---
local DEFAULT_BLAST_COLOR = {255, 97, 0}
--- ==== ---


--- Local functions ---
local function update_blast(e, world, dt)
	local blast = e.Blast

	if blast.radius and blast.duration and blast.func then
		blast.progress = blast.progress or 0
		blast.affected = blast.affected or {}

		---

		blast.progress = blast.progress + (dt/blast.duration)
		if blast.progress > 1 then
			world:remove_entity(e)
			return
		end

		local current_radius = blast.progress * blast.radius

		for affected in pairs(world.hash:get_objects_in_range(
			circle.aabb(current_radius, e.Position.x, e.Position.y)))
		do
			if not blast.affected[affected] then
				local dist_vec = (affected.Position - e.Position)
				local dir_vec = dist_vec:normalized()

				if affected.Radius then
					dist_vec = dist_vec - (dir_vec * affected.Radius)
				end
				local dist = dist_vec:len()

				local in_circle = 1 - (dist/current_radius)

				if in_circle > 0 then
					blast.affected[affected] = true

					local impact = 1 - (dist/blast.radius)
					blast.func(affected, impact, dir_vec)
				end
			end
		end
	end
end

local function draw_blast(e)
	local blast = e.Blast

	local color = e.Color or DEFAULT_BLAST_COLOR

	local cradius = e.Blast.radius * e.Blast.progress
	local fade = 1 - e.Blast.progress

	love.graphics.setColor(color[1], color[2], color[3], fade * 255)
	love.graphics.circle("line", e.Position.x, e.Position.y, cradius)

	love.graphics.setColor(color[1], color[2], color[3], fade * 64)
	love.graphics.circle("fill", e.Position.x, e.Position.y, cradius)
end

local function draw_entity_debug_info(e)
	local str_t = {}

	---

	--str_t[#str_t + 1] = (""):format()

	str_t[#str_t + 1] = ("Position: (%.2f, %.2f)"):format(e.Position.x, e.Position.y)
	str_t[#str_t + 1] = ("Blast progress: %.2f"):format(e.Blast.progress)

	---

	local str = table.concat(str_t, "\n")

	local text_w = love.graphics.getFont():getWidth(str)

	local x = e.Position.x
	local y = e.Position.y

	love.graphics.setColor(255, 255, 255)
	love.graphics.print(str, math.floor(x), math.floor(y))
end
--- ==== ---


--- System functions ---
function sys_Blast:process(e, dt)
	local world = self.world.world

	update_blast(e, world, dt)
	draw_blast(e)

	if world.DEBUG then
		draw_entity_debug_info(e)
	end
end
--- ==== ---

return Class(sys_Blast)
