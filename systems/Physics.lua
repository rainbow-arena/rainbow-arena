--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")

local circle = require("util.circle")
--- ==== ---


--- System definition ---
local Physics = tiny.processingSystem()
Physics.filter = tiny.requireAll("Position", "Radius", "Velocity")
--- ==== ---


--- Local functions ---
local function get_entity_aabb(e)
	return circle.aabb(e.Radius, e.Position.x, e.Position.y)
end

local function are_entities_colliding(e1, e2)
	return circle.colliding(e1.Position, e1.Radius, e2.Position, e2.Radius)
end

---

-- TODO: Add functionality.
local function can_entities_collide(world, e1, e2)
	return true
end

---

-- Only call this function with e1 having Velocity.
local function resolve_collision(world, e1, e2, mtv)
	if e1.Mass == 0 then
		world:move_entity(e1, e1.Position + mtv)
	elseif e2.Mass == 0 then
		world:move_entity(e2, e2.Position + mtv)

	else
		local masses = (e1.Mass + e2.Mass)
		world:move_entity(e1, e2.Position + (e2.Mass/masses) * mtv)
		world:move_entity(e1, e2.Position - (e2.Mass/masses) * mtv)
	end

	if e2.Velocity then
		-- Dynamic vs. Dynamic
		local e1_normal_velocity = e1.Velocity:projectOn(mtv)
		local e1_tangent_velocity = e1.Velocity - e1_normal_velocity

		local e2_normal_velocity = e2.Velocity:projectOn(mtv)
		local e2_tangent_velocity = e2.Velocity - e2_normal_velocity

		local e1_mass = e1.Mass
		local e2_mass = e2.Mass

		-- We only care about normal velocity - the tangent velocities remain the same.
		-- Velocity equations: https://en.wikipedia.org/wiki/Elastic_collision
		local e1_final_normal_velocity =
			(e1_normal_velocity * (e1_mass - e2_mass) + 2 * e2_mass * e2_normal_velocity)
			/ (e1_mass + e2_mass)
		local e2_final_normal_velocity =
			(e2_normal_velocity * (e2_mass - e1_mass) + 2 * e1_mass * e1_normal_velocity)
			/ (e2_mass + e1_mass)

		e1.Velocity = e1_tangent_velocity + e1_final_normal_velocity
		e2.Velocity = e2_tangent_velocity + e2_final_normal_velocity
	else
		-- Dynamic vs. Static
		local normal_velocity = entity.Velocity:projectOn(mtv)
		local tangent_velocity = entity.Velocity - normal_velocity
		entity.Velocity = -normal_velocity + tangent_velocity
	end
end

---

-- This metatable creates tables where nil accesses occur.
local col_pairs = setmetatable({}, {
		__index = function(self, key)
			local t = setmetatable({}, {__mode = "k"})
			rawset(self, key, t)
			return t
		end,

		__mode = "k"
	}
)

local function add_pair(ent1, ent2)
	col_pairs[ent1][ent2] = true
	col_pairs[ent2][ent1] = true
end

local function remove_pair(ent1, ent2)
	col_pairs[ent1][ent2] = nil
	col_pairs[ent2][ent1] = nil
end

local function check_pair(ent1, ent2)
	return col_pairs[ent1] and col_pairs[ent1][ent2] --and col_pairs[ent2] and col_pairs[ent2][ent1]
end

local function get_pairs(ent)
	return col_pairs[ent]
end
--- ==== ---


--- System functions ---
function Physics:onAddToWorld(world)
	local world = world.world


	-- Relay collision events if entities can collide.
	world:register_event("_EntityCollision", function(world, e1, e2, mtv)
		if can_entities_collide() then
			world:emit_event("EntityCollision", e1, e2, mtv)
		end
	end)

	world:register_event("_EntityColliding", function(world, e1, e2, mtv)
		if can_entities_collide() then
			world:emit_event("EntityColliding", e1, e2, mtv)
		end
	end)

	world:register_event("_EntityCollisionStop", function(world, e1, e2)
		if can_entities_collide() then
			world:emit_event("EntityCollisionStop", e1, e2)
		end
	end)

	---

	-- Resolve collisions.
	world:register_event("EntityCollision", function(world, e1, e2)
		local REQ = {
			"Mass"
		}

		if util.table.has(ent1, REQ) and util.table.has(ent2, REQ) then
			world:emit_event("PhysicsCollision", ent1, ent2, mtv)
			resolve_collision(world, ent1, ent2, mtv)
		end
	end)
end

function Physics:process(e, dt)
	local world = self.world.world

	--- Apply Velocity to Position.
	world:move_entity(e, e.Position + e.Velocity * dt)


	--- Apply Acceleration to Velocity.
	if e.Acceleration then
		e.Velocity = e.Velocity + (e.Acceleration * e.Velocity) * dt
	end


	--- Detect collisions.
	-- First, check whether any registered collisions have stopped.
	for other in pairs(get_pairs(e)) do
		if not are_ents_colliding(e, other) then
			remove_pair(e, other)
			world:emit_event("_EntityCollisionStop", e, other)
		end
	end

	-- Then, check for collisions.
	for other in pairs(world.hash:get_objects_in_range(get_entity_aabb(e))) do
		if other ~= e then
			local col, mtv = are_entities_colliding(e, other)

			if col then
				if not check_pair(e, other) then
					add_pair(e, other)
					world:emit_event("_EntityCollision", e, other, mtv)
				end

				world:emit_event("_EntityColliding", e, other, mtv)
			end
		end
	end
end
--- ==== ---

return Class(Physics)