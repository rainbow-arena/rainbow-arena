--- Require ---
local Class = require("lib.hump.class")
local signal = require("lib.hump.signal")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local SH = require("lib.spatialhash")
local util = require("lib.util")

local circle = require("util.circle")
--- ==== ---


--- Class definition ---
local World = {}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
-- Main --
function World:init(system_dir)
	self.ecs = tiny.world()
	self.ecs.world = self

	self.hash = SH.new()
	self.event = signal.new()
end

function World:update(dt)
	self.ecs:update(dt)
end

function World:draw()

end
-- ==== --


-- Entities --
function World:add_entity(e)
	e = self.ecs:addEntity(e)

	if e.Position and e.Radius then
		self.hash:insert_object(e, circle.aabb(
			e.Radius, e.Position.x,e.Position.y))
	end
end

function World:move_entity(e, newpos_vec)
	assert(vector.isvector(newpos_vec), "Entity destination must be a vector!")

	local oldpos_vec = e.Position
	e.Position = newpos_vec

	if e.Radius then
		local old_x1,old_y1, old_x2,old_y2 = circle_aabb(e.Radius, oldpos_vec.x, oldpos_vec.y)
		local new_x1,new_y1, new_x2,new_y2 = circle_aabb(e.Radius, newpos_vec.x, newpos_vec.y)

		self.hash:move_object(entity, old_x1,old_y1, old_x2,old_y2, new_x1,new_y1, new_x2,new_y2)
	end
end

function World:remove_entity(e)
	if e.Position and e.Radius then
		self.hash:remove_object(e, circle.aabb(
			e.Radius, e.Position.x, e.Position.y))
	end

	self.ecs:removeEntity(e)
end
-- ==== --


-- Events --
function World:register_event(event, func)
	self.event.register(event, func)
end

function World:emit_event(event, ...)
	self.event.emit(event, self, ...)
end
-- ==== --
--- ==== ---


return Class(World)
