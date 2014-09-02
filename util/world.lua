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

---

local function load_systems(world, dir)
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
					world:addSystem(system)
				end
			end
			if t.events then
				for _, eventitem in pairs(t.events) do
					world:registerEvent(eventitem.event, eventitem.func)
				end
			end
		end
	end
end

---

local function new()
	local w = ces.new()

	---

	w.camera = camera.new()
	w.signal = signal.new()
	w.timer = timer.new()
	w.screenshake = 0
	w.hash = spatialhash.new()
	w.speed = 1

	---

	function w:registerEvent(event, func)
		self.signal:register(event, func)
	end

	function w:emitEvent(event, ...)
		self.signal:emit(event, self, ...)
	end

	function w:clearEvents()
		self.signal:clear()
	end

	local olddestroy = w.destroyEntity
	function w:destroyEntity(entity)
		self:emitEvent("EntityDestroyed", entity)
		olddestroy(self, entity)
	end

	---

	local oldspawn = w.spawnEntity
	function w:spawnEntity(t)
		local entity = oldspawn(self, t)

		if entity.Position and entity.Radius then
			self.hash:insert_object(entity, aabb(
				entity.Radius, entity.Position.x, entity.Position.y))
		end

		return entity
	end

	local olddestroy = w.destroyEntity
	function w:destroyEntity(entity)
		olddestroy(self, entity)

		if entity.Position and entity.Radius then
			self.hash:remove_object(entity, aabb(
				entity.Radius, entity.Position.x, entity.Position.y))
		end
	end

	function w:move_entity_to(entity, x, y)
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

	---

	load_systems(w, "systems")

	---

	return w
end

return {
	new = new
}
