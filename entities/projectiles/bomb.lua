local util = require("lib.self.util")

---

local class = require("lib.hump.class")

---

local e_proj_physical = require("entities.projectiles.physical")
local e_proj_bomb = class{__includes = e_proj_physical}

---

-- 300 is good muzzle speed.
function e_proj_bomb:init(arg)
	arg = arg or {}

	arg.radius = arg.radius or 10
	arg.mass = arg.mass or 700

	e_proj_physical.init(self, arg)
end

function e_proj_bomb:on_collision(world, target, mtv)
	local exp = require("entities.effects.explosion"){
		position = self.Position:clone()
	}

	world:spawn_entity(exp)
	world:destroy_entity(self)

	e_proj_physical.on_collision(self, world, target, mtv)
end

function e_proj_bomb:on_arena_collision(world, pos, side)
	local exp = require("entities.effects.explosion"){
		position = self.Position:clone()
	}

	world:spawn_entity(exp)
	world:destroy_entity(self)

	e_proj_physical.on_arena_collision(self, world, pos, side)
end

---

return e_proj_bomb
