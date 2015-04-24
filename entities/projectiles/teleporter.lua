local class = require("lib.hump.class")

---

local e_proj_physical = require("entities.projectiles.physical")
local e_proj_teleporter = class{__includes = e_proj_physical}

---

function e_proj_teleporter:init(arg)
	arg = arg or {}

	arg.radius = arg.radius or 10
	arg.color = {200, 50, 200}

	e_proj_physical.init(self, arg)
end

function e_proj_teleporter:on_collision(world, target, mtv)
	if target ~= self.Firer then
		world:move_entity(self.Firer, self.Position)
	end
	world:destroy_entity(self)

	e_proj_physical.on_collision(self, world, target, mtv)
end

function e_proj_teleporter:on_arena_collision(world, pos, side)
	world:move_entity(self.Firer, pos)
	world:destroy_entity(self)

	e_proj_physical.on_arena_collision(self, world, pos, side)
end

---

return e_proj_teleporter
