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

	self.DeathExplosion = {
		color = arg.explosion_color or {255, 97, 0},
		radius = arg.explosion_radius or 200,
		force = arg.explosion_force or 10^6,
		damage = arg.explosion_damage or 10,
		screenshake = arg.explosion_shake or 3,
		duration = arg.explosion_duration or 1
	}

	e_proj_physical.init(self, arg)
end

function e_proj_bomb:on_collision(world, target, mtv)
	self.Health = 0

	e_proj_physical.on_collision(self, world, target, mtv)
end

function e_proj_bomb:on_arena_collision(world, pos, side)
	self.Health = 0

	e_proj_physical.on_arena_collision(self, world, pos, side)
end

---

return e_proj_bomb
