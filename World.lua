--- Require ---
local Class = require("lib.hump.class")
local signal = require("lib.hump.signal")
local vector = require("lib.hump.vector")
local camera = require("lib.hump.camera")

local tiny = require("lib.tiny")

local SH = require("lib.spatialhash")
local util = require("lib.util")

local circle = require("util.circle")
local file = require("util.file")
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

	---

	self.speed = 1

	---

	self:load_systems(system_dir or "systems")
end

function World:update(dt)
	self.dt = dt
	self.ecs:update(dt * self.speed, tiny.rejectAll("isDrawSystem"))
end

function World:draw()
	self.ecs:update(self.dt * self.speed, tiny.requireAll("isDrawSystem"))
end
-- ==== --


-- Entities --
function World:add_entity(e)
	e = self.ecs:addEntity(e)

	if e.Position and e.Radius then
		self.hash:insert_object(e, circle.aabb(
			e.Radius, e.Position.x,e.Position.y))
	end

	return e
end

function World:move_entity(e, newpos_vec)
	assert(vector.isvector(newpos_vec), "Entity destination must be a vector!")

	local oldpos_vec = e.Position
	e.Position = newpos_vec

	if e.Radius then
		local old_x1,old_y1, old_x2,old_y2 = circle.aabb(e.Radius, oldpos_vec.x, oldpos_vec.y)
		local new_x1,new_y1, new_x2,new_y2 = circle.aabb(e.Radius, newpos_vec.x, newpos_vec.y)

		self.hash:move_object(e, old_x1,old_y1, old_x2,old_y2, new_x1,new_y1, new_x2,new_y2)
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


-- Systems --
function World:load_systems(system_dir)
	file.diriter(system_dir, function(dir, item)
		if item:find(".lua$") then
			print("Adding system: " .. dir .. "/" .. item)
			local system = love.filesystem.load(dir .. "/" .. item)()
			self.ecs:addSystem(system)
		end
	end)
end
-- ==== --
--- ==== ---


return Class(World)
