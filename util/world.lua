local ces = require("lib.self.ces")
local spatialhash = require("lib.self.spatialhash")

local camera = require("lib.hump.camera")
local vector = require("lib.hump.vector")
local signal = require("lib.hump.signal")
local timer = require("lib.hump.timer")

local circleutil = require("util.circle")

---

local aabb = circleutil.aabb

---

local world = {}
world.__index = world

---

function world:register_event(event, func)
	self.signal:register(event, func)
end

function world:emit_event(event, ...)
	self.signal:emit(event, self, ...)
end

function world:spawn_entity(t)
	local entity = self.ces:spawn_entity(t)

	if entity.Position and entity.Radius then
		self.hash:insert_object(entity, aabb(
			entity.Radius, entity.Position.x, entity.Position.y))
	end
end

function world:destroy_entity(entity)
	self.ces:destroy_entity(entity)

	if entity.Position and entity.Radius then
		self.hash:remove_object(entity, aabb(
			entity.Radius, entity.Position.x, entity.Position.y))
	end
end

function world:move_entity(entity, x, y)
	local oldpos = entity.Position

	local newpos
	if not y then
		newpos = x
	else
		newpos = vector.new(x, y)
	end

	entity.Position = newpos

	local old_x1,old_y1, old_x2,old_y2 = aabb(entity.Radius, oldpos.x, oldpos.y)
	local new_x1,new_y1, new_x2,new_y2 = aabb(entity.Radius, newpos.x, newpos.y)

	self.hash:move_object(entity, old_x1,old_y1, old_x2,old_y2, new_x1,new_y1, new_x2,new_y2)
end

function world:load_system_dir(dir)
	for _, item in ipairs(love.filesystem.getDirectoryItems(dir)) do
		if love.filesystem.isDirectory(dir .. "/" .. item) then
			load_systems(world, dir .. "/" .. item)
		else
			local t = love.filesystem.load(dir .. "/" .. item)()

			if type(t) ~= "table" then
				error(("System file \"%s\" doesn't return a table!"):format(dir .."/" .. item))
			end

			if t.systems then
				for _, system in ipairs(t.systems) do
					world:add_system(system)
				end
			end
			if t.events then
				for _, eventitem in pairs(t.events) do
					world:register_event(eventitem.event, eventitem.func)
				end
			end
		end
	end
end

---

local function new()
	local w = {
		ces = ces.new(),
		signal = signal.new(),
		hash = spatialhash.new(),
		timer = timer.new(),
		camera = camera.new(),

		screenshake = 0,
		speed = 1
	}

	return setmetatable(w, world)
end

return {
	new = new
}
