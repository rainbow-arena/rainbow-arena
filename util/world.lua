local ces = require("lib.self.ces")
local spatialhash = require("lib.self.spatialhash")
local screenshake = require("lib.self.screenshake")

local camera = require("lib.hump.camera")
local vector = require("lib.hump.vector")
local signal = require("lib.hump.signal")
local timer = require("lib.hump.timer")

local util = require("lib.self.util")

local circleutil = require("util.circle")

---

local clamp = util.math.clamp

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

	return entity
end

function world:get_entities_with(components)
	return self.ces:get_entities_with(components)
end

function world:destroy_entity(entity)
	self.ces:destroy_entity(entity)

	if entity.Position and entity.Radius then
		self.hash:remove_object(entity, aabb(
			entity.Radius, entity.Position.x, entity.Position.y))
	end
end

function world:clear_entities()
	self.ces:clear_entities()
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

function world:add_system(arg)
	self.ces:add_system(arg)
end

function world:run_systems(kind, ...)
	self.ces:run_systems(kind, self, ...)
end

function world:load_system_dir(dir)
	for _, item in ipairs(love.filesystem.getDirectoryItems(dir)) do
		if love.filesystem.isDirectory(dir .. "/" .. item) then
			self:load_system_dir(dir .. "/" .. item)
		else
			local t = love.filesystem.load(dir .. "/" .. item)()

			if type(t) ~= "table" then
				error(("System file \"%s\" doesn't return a table!"):format(dir .."/" .. item))
			end

			if t.systems then
				for _, system in ipairs(t.systems) do
					self:add_system(system)
				end
			end
			if t.events then
				for _, eventitem in pairs(t.events) do
					self:register_event(eventitem.event, eventitem.func)
				end
			end
		end
	end
end

---

function world:update(dt)
	self.speed = clamp(0, self.speed, 7)
	local adjdt = dt * self.speed

	love.audio.setPosition(self.camera.x/SOUND_POSITION_SCALE, self.camera.y/SOUND_POSITION_SCALE, 0)

	-- TODO: Overhaul screenshake, make it slower when game slows,
	-- when speed == 0, it pauses.
	self.screenshake = 0

	if adjdt > 0 then
		self.bg_pulse_level = self.bg_pulse_level - (adjdt/self.bg_pulse_length)
		if self.bg_pulse_level <= 0 then
			self.bg_pulse_level = 0
		end

		self.timer:update(adjdt)
		self:run_systems("update", adjdt)
	end
end

function world:draw(on_camera, off_camera)
	self.camera:attach()

	screenshake.apply(self.screenshake, self.screenshake)

	love.graphics.setColor(self.bg_color[1], self.bg_color[2], self.bg_color[3], self.bg_pulse_level*255)
	love.graphics.rectangle("fill", 0, 0, self.w, self.h)

	-- Arena boundaries.
	love.graphics.setColor(255, 255, 255)
	love.graphics.line(0,0, 0,self.h)
	love.graphics.line(0,self.h, self.w,self.h)
	love.graphics.line(self.w,self.h, self.w,0)
	love.graphics.line(self.w,0, 0,0)

	if on_camera then
		on_camera(self)
	end

	self:run_systems("draw")
	self.camera:detach()

	---

	if off_camera then
		off_camera(self)
	end
end

---

function world:pulse_bg()
	self.bg_pulse_level = self.bg_pulse_max or 1
end

---

local function new(width, height)
	local w = {
		w = width, h = height,

		ces = ces.new(),
		signal = signal.new(),
		hash = spatialhash.new(),
		timer = timer.new(),
		camera = camera.new(),

		bg_color = {255, 255, 255},
		bg_pulse_length = 1,
		bg_pulse_level = 0,
		bg_pulse_max = 0.8,

		screenshake = 0,
		speed = 1
	}

	w.entities = w.ces.entities

	return setmetatable(w, world)
end

return {
	new = new
}
