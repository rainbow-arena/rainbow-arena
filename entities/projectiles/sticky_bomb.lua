local vector = require("lib.hump.vector")
local util = require("lib.self.util")

---

local class = require("lib.hump.class")

---

local e_proj_bomb = require("entities.projectiles.bomb")
local e_proj_sticky_bomb = class{__includes = e_proj_bomb}

---

function e_proj_sticky_bomb:init(arg)
	arg = arg or {}

	self.MaxHealth = arg.detonate_delay or 3
	self.Health = self.MaxHealth

	self.DeathExplosion = {
		color = arg.explosion_color or {255, 97, 0},
		radius = arg.explosion_radius or 200,
		force = arg.explosion_force or 10^6,
		damage = arg.explosion_damage or 10,
		screenshake = arg.explosion_shake or 3,
		duration = arg.explosion_duration or 1
	}

	e_proj_bomb.init(self, arg)
end

function e_proj_sticky_bomb:stick(target)
	local offset = self.Position - target.Position
	self.AttachedTo = target
	self.AttachmentOffset = offset
	self.Velocity = vector.new(0, 0)
	self.HealthDrainRate = 1
end

function e_proj_sticky_bomb:on_collision(world, target, mtv)
	if not self.stuck then
		self.stuck = true
		self:stick(target)
	end
end

function e_proj_sticky_bomb:on_arena_collision(world, pos, side)
	e_proj_bomb.on_arena_collision(self, world, pos, side)
end

---

return e_proj_sticky_bomb
