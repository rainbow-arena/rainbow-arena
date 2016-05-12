--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local circle = require("util.circle")
--- ==== ---


--- System ---
local sys_Parent = Class(tiny.processingSystem())
sys_Parent.filter = tiny.requireAll("Position", "Parent", "AttachmentOffset")
--- ==== ---


--- Constants ---
--- ==== ---


--- Local functions ---
local function draw_entity_debug_info(e)
	local str_t = {}

	---

	--str_t[#str_t + 1] = (""):format()

	str_t[#str_t + 1] = ("Parent: %s"):format(e.Position.x, e.Position.y)

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
function sys_Parent:process(e, dt)
	local world = self.world.world

	---

	if world.entities[parent] then
		local parent = e.Parent

		e.Position = parent.Position:clone() + e.AttachmentOffset

		if e.Velocity then
			if parent.Velocity then
				e.Velocity = parent.Velocity:clone()
			elseif e.Velocity.x ~= 0 or e.Velocity.y ~= 0 then
				e.Velocity = vector.zero:clone()
			end
		end
	elseif e.RemoveWithParent then
		world:remove_entity(e)
	else
		e:set_parent()
	end

	---

	if world.DEBUG then
		--draw_entity_debug_info(e)
	end
end
--- ==== ---

return sys_Parent
