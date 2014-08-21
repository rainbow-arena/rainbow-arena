-- A Component Entity System.
-- Registry system based on hump.signal by vrld.
-- Uses hump.signal for an event system.

local Registry = {}

local signal = require("lib.hump.signal")
local util = require("lib.self.util")

---

function Registry:registerEvent(event, func)
	self.signal:register(event, func)
end

function Registry:emitEvent(event, ...)
	self.signal:emit(event, self, ...)
end

function Registry:clearEvents()
	self.signal:clear()
end

---

--[[
	args = {
		name = <system name>,
		priority = <a number; systems with higher numbers run first>,
		requires = {<components that this system requires in an entity>},

		update = function(entity, world, ...)

		end,
		OR
		draw = function(entity, world, ...)

		end,

		events = {
			event = function(...)

			end
		}
	}
]]

local function sortOrderTable(systems, ordert)
	table.sort(ordert, function(a, b)
		return systems[a].priority > systems[b].priority
	end)
end

function Registry:addSystem(args)
	--assert(args.name and args.requires and (args.update or args.draw),
	--	"Missing argument to addSystem")

	assert(not self.systems[args.name],
		"System \"" .. args.name .. "\" already exists")

	self.systems[args.name] = {
		priority = args.priority or 0,
		requires = args.requires,
		func = args.update or args.draw
	}

	local orderTable = args.draw and self.drawOrder or self.updateOrder
	table.insert(orderTable, args.name)
	sortOrderTable(self.systems, orderTable)
end

function Registry:removeSystem(name)
	self.systems[name] = nil
	-- TODO: remove event handlers associated with the system
end

function Registry:spawnEntity(components)
	local entity = util.table.clone(components) or {}
	self.entities[entity] = entity
	return entity
end

function Registry:getEntitiesWith(components)
	local result = {}
	for entity in pairs(self.entities) do
		local add = true
		for _, component in ipairs(components) do
			if not entity[component] then
				add = false
			end
		end
		if add then result[entity] = entity end
	end
	return result
end

function Registry:destroyEntity(entity)
	self.destroyQueue[entity] = entity
end

function Registry:clearEntities()
	--self.entities = {}
	for entity in pairs(self.entities) do
		self:destroyEntity(entity)
	end
end

--[[
	args = {
		name = <name of system>,
		entities = <a table of entities to run this system on, or nil to use all entities>,
		userdata = <anything that you want to pass to the system>
	}
]]

local function runSystemOnEntity(system, entity, ...)
	if util.table.has(entity, system.requires or {}) then
		system.func(entity, ...)
	end
end

function Registry:runSystem(args)
	assert(args.name, "System name not supplied to runSystem")

	local system = self.systems[args.name]
	if not system then
		error("System \"" .. args.name .. "\" not found")
	end

	for entity in pairs(self.entities) do
		if type(args.userdata) == "table" then
			runSystemOnEntity(system, entity, unpack(args.userdata))
		else
			runSystemOnEntity(system, entity, args.userdata)
		end
	end
end

function Registry:runSystems(kind, ...)
	local orderTable = (kind == "draw") and self.drawOrder or self.updateOrder

	self.destroyQueue = {}

	for i, system in ipairs(orderTable) do

		if not self.systems[system] then -- If the system can't be found, it has probably been removed.
			orderTable[i] = nil
		end

		love.graphics.setColor(255, 255, 255)
		self:runSystem{ name = system, userdata = {self, ...} }
	end

	for entity in pairs(self.destroyQueue) do
		self:emitEvent("EntityDestroyed", entity)
		self.entities[entity] = nil
	end
end

---

local function new()
	return setmetatable({
		signal = signal.new(),
		systems = {},
		updateOrder = {},
		drawOrder = {},
		entities = setmetatable({}, {__len = function(self)
			local count = 0
			for kv in pairs(self) do count = count + 1 end
			return count
		end}),
		destroyQueue = {}
	}, { __index = Registry })
end

return {
	new = new
}
