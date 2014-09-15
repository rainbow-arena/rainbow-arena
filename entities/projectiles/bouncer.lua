local class = require("lib.hump.class")

---

local e_proj_physical = require("entities.projectiles.physical")
local e_proj_bouncer = class{__includes = e_proj_physical}

---

function e_proj_bouncer:init(arg)
	arg = arg or {}

	self.bounces = arg.bounces or 1
	self.CollisionPhysics = true

	e_proj_physical.init(self, arg)
end

function e_proj_bouncer:on_collision(world, target, mtv)
	self.bounces = self.bounces - 1
	if self.bounces < 0 then
		world:destroy_entity(self)
	end

	e_proj_physical.on_collision(self, world, target, mtv)
end

---

return e_proj_bouncer
