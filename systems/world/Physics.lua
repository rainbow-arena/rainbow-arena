local check = require("logic.circle").colliding
local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local invert = util.table.invert

local function collision_eligible(ent1, ent2)
	if ent1 == ent2 then return false end

	if ent1.CollisionExcludeEntities then
		if invert(ent1.CollisionExcludeEntities)[ent2] then
			return false
		end
	end

	if ent2.CollisionExcludeEntities then
		if invert(ent2.CollisionExcludeEntities)[ent1] then
			return false
		end
	end

	---

	if ent1.CollisionExcludeComponents then
		for _, comp in ipairs(ent1.CollisionExcludeComponents) do
			if ent2[comp] then
				return false
			end
		end
	end

	if ent2.CollisionExcludeComponents then
		for _, comp in ipairs(ent2.CollisionExcludeComponents) do
			if ent1[comp] then
				return false
			end
		end
	end

	return true
end

return {
	systems = {
		{
			name = "CalculateMass",
			requires = {"Radius"},
			priority = 4,
			update = function(entity)
				if not entity.Mass then
					entity.Mass = math.pi * entity.Radius^2
				end
			end
		},
		{
			name = "CalculateAcceleration",
			requires = {"InputAcceleration"},
			priority = 2,
			update = function(entity)
				entity.Acceleration = (entity.InputAcceleration or vector.zero)
			end
		},

		-- https://stackoverflow.com/questions/667034/simple-physics-based-movement
		-- v_max = acc/drag, time_to_v_max = 5/drag
		{
			name = "Motion",
			requires = {"Position", "Velocity"},
			priority = 1,
			update = function(entity, world, dt)
				entity.Position = entity.Position + entity.Velocity*dt
				entity.Velocity = entity.Velocity + ((entity.Acceleration or vector.zero) - (entity.Drag or 0) * entity.Velocity)*dt
			end
		},

		{
			name = "Collision",
			requires = {"Position", "Velocity", "Radius"},
			update = function(entity, world, dt)
				-- TODO: Narrow collision candidates?
				for other in pairs(world:getEntitiesWith{"Position", "Radius"}) do
					if collision_eligible(entity, other) then
						local col, mtv = check(entity.Position,entity.Radius,
							other.Position,other.Radius)
						if col then
							world:emitEvent("EntityCollision", entity, other, mtv)
						end
					end
				end
			end,
		},

		{
			name = "ArenaCollision",
			requires = {"Position", "Velocity", "Radius", "CollisionPhysics"},
			update = function(entity, world, dt, camera, arena_w, arena_h)
				local pos, radius = entity.Position, entity.Radius

				-- Left
				if pos.x - radius < 0 then
					entity.Position.x = radius
					entity.Velocity.x = -entity.Velocity.x

					world:emitEvent("ArenaCollision", entity, vector.new(pos.x - radius, pos.y), "left")
				end

				-- Right
				if pos.x + radius > arena_w then
					entity.Position.x = arena_w - radius
					entity.Velocity.x = -entity.Velocity.x

					world:emitEvent("ArenaCollision", entity, vector.new(pos.x + radius, pos.y), "right")
				end

				-- Top
				if pos.y - radius < 0 then
					entity.Position.y = radius
					entity.Velocity.y = -entity.Velocity.y

					world:emitEvent("ArenaCollision", entity, vector.new(pos.x, pos.y - radius), "top")
				end

				-- Bottom
				if pos.y + radius > arena_h then
					entity.Position.y = arena_h - radius
					entity.Velocity.y = -entity.Velocity.y

					world:emitEvent("ArenaCollision", entity, vector.new(pos.x, pos.y + radius), "left")
				end
			end
		},

		{
			name = "DestroyAfterLifetime",
			requires = {"Lifetime"},
			update = function(entity, world, dt)
				entity.Lifetime = entity.Lifetime - dt

				if entity.Lifetime <= 0 then
					world:destroyEntity(entity)
				end
			end
		},
		{
			name = "DestroyOutsideArena",
			requires = {"Position", "ArenaBounded"},
			update = function(entity, world, dt, camera, arena_w, arena_h)
				local tolerance = entity.ArenaBounded or 0
				if entity.Position.x < 0 - tolerance or entity.Position.x > arena_w + tolerance
					or entity.Position.y < 0 - tolerance or entity.Position.y > arena_h + tolerance
				then
					world:destroyEntity(entity)
				end
			end
		}
	},

	events = {
		{ -- Call the collision functions of entities if they have them.
			event = "EntityCollision",
			func = function(world, ent1, ent2, mtv)
				if ent1.OnEntityCollision then
					ent1:OnEntityCollision(world, ent2, mtv)
				end

				if ent2.OnEntityCollision then
					ent2:OnEntityCollision(world, ent1, mtv)
				end
			end
		},

		{ -- Collision physics.
			event = "EntityCollision",
			func = function(world, ent1, ent2, mtv)
				if not ent1.CollisionPhysics or not ent2.CollisionPhysics
				then return end

				---

				world:emitEvent("PhysicsCollision", ent1, ent2, mtv)

				---

				ent1.Position = ent1.Position + mtv

				if ent2.Velocity then
					-- Dynamic vs. Dynamic
					local ent1_normal_velocity = ent1.Velocity:projectOn(mtv)
					local ent1_tangent_velocity = ent1.Velocity - ent1_normal_velocity

					local ent2_normal_velocity = ent2.Velocity:projectOn(mtv)
					local ent2_tangent_velocity = ent2.Velocity - ent2_normal_velocity

					local ent1_mass = ent1.Mass
					local ent2_mass = ent2.Mass

					-- We only care about normal velocity - the tangent velocities remain the same.
					-- Velocity equations: https://en.wikipedia.org/wiki/Elastic_collision
					local ent1_final_normal_velocity =
						(ent1_normal_velocity * (ent1_mass - ent2_mass) + 2 * ent2_mass * ent2_normal_velocity)
						/ (ent1_mass + ent2_mass)
					local ent2_final_normal_velocity =
						(ent2_normal_velocity * (ent2_mass - ent1_mass) + 2 * ent1_mass * ent1_normal_velocity)
						/ (ent2_mass + ent1_mass)

					ent1.Velocity = ent1_tangent_velocity + ent1_final_normal_velocity
					ent2.Velocity = ent2_tangent_velocity + ent2_final_normal_velocity
				else
					-- Dynamic vs. Static
					local normal_velocity = entity.Velocity:projectOn(mtv)
					local tangent_velocity = entity.Velocity - normal_velocity
					entity.Velocity = -normal_velocity + tangent_velocity
				end
			end
		}
	}
}
