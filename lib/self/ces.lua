-- A Component Entity System.
-- Registry system based on hump.signal by vrld.

local Registry = {}


local util = require("lib.self.util")

---

local table_clone = util.table.clone
local table_has = util.table.has

---

--[[
	args = {
		name = <system name>,
		priority = <a number; systems with higher numbers run first>,
		requires = {<components that this system requires in an entity>},

		update = function(entity, world, ...)

		end
		OR
		draw = function(entity, world, ...)

		end
	}
]]

local function sort_order_table(systems, ordert)
	table.sort(ordert, function(a, b)
		return systems[a].priority > systems[b].priority
	end)
end

function Registry:add_system(args)
	--assert(args.name and args.requires and (args.update or args.draw),
	--	"Missing argument to add_system")

	assert(not self.systems[args.name],
		"System \"" .. args.name .. "\" already exists")

	self.systems[args.name] = {
		priority = args.priority or 0,
		requires = args.requires,
		func = args.update or args.draw
	}

	local order_table = args.draw and self.draw_order or self.update_order
	table.insert(order_table, args.name)
	sort_order_table(self.systems, order_table)
end

function Registry:remove_system(name)
	self.systems[name] = nil
end

function Registry:spawn_entity(components)
	local entity = table_clone(components) or {}
	self.entities[entity] = entity
	return entity
end

function Registry:get_entities_with(components)
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

function Registry:destroy_entity(entity)
	self.destroy_queue[entity] = entity
end

function Registry:clear_entities()
	--self.entities = {}
	for entity in pairs(self.entities) do
		self:destroy_entity(entity)
	end
end

function Registry:run_system(name, ...)
	assert(name, "System name not supplied to run_system")

	local system = self.systems[name]
	if not system then
		error("System \"" .. name .. "\" not found")
	end

	if not system.requires then
		-- Run just once with no entity.
		system.func(nil, ...)
	elseif #system.requires == 0 then
		-- Run on all entities.
		for entity in pairs(self.entities) do
			system.func(entity, ...)
		end
	else
		-- Run on entities with required components.
		for entity in pairs(self.entities) do
			if table_has(entity, system.requires) then
				system.func(entity, ...)
			end
		end
	end
end

function Registry:run_systems(kind, ...)
	local order_table = (kind == "draw") and self.draw_order or self.update_order

	self.destroy_queue = {}

	for i, system in ipairs(order_table) do

		if not self.systems[system] then -- If the system can't be found, it has probably been removed.
			order_table[i] = nil
		end

		love.graphics.setColor(255, 255, 255)
		self:run_system(system, ...)
	end

	for entity in pairs(self.destroy_queue) do
		self.entities[entity] = nil
	end
end

---

local function new()
	return setmetatable({
		systems = {},
		update_order = {},
		draw_order = {},
		entities = setmetatable({}, {__len = function(self)
			local count = 0
			for kv in pairs(self) do count = count + 1 end
			return count
		end}),
		destroy_queue = {}
	}, { __index = Registry })
end

return {
	new = new
}
