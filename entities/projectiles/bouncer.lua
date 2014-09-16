local class = require("lib.hump.class")

---

local e_proj_physical = require("entities.projectiles.physical")
local e_proj_bouncer = class{__includes = e_proj_physical}

---

function e_proj_bouncer:init(arg)
	arg = arg or {}

	self.bounces = arg.bounces or 3
	self.CollisionPhysics = true

	e_proj_physical.init(self, arg)
end

function e_proj_bouncer:on_collision(world, target, mtv)
	if self.last_bounce_target ~= target then
		self.bounces = self.bounces - 1
		self.last_bounce_target = target

		-- Minimise bouncing off the same object twice in rapid succession.
		world.timer:add(0.08, function()
			self.last_bounce_target = nil
		end)

		if self.bounces < 0 then
			world:destroy_entity(self)
		end
	end

	e_proj_physical.on_collision(self, world, target, mtv)
end

function e_proj_bouncer:on_arena_collision(world, pos, side)
	self.bounces = self.bounces - 1
	if self.bounces < 0 then
		world:destroy_entity(self)
	end

	e_proj_physical.on_arena_collision(self, world, pos, side)
end

---

return e_proj_bouncer
