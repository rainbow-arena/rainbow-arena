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

	e_proj_bomb.init(self, arg)
end

function e_proj_sticky_bomb:stick(target, mtv)
	self.Parent = target
	self.AttachmentOffset = mtv:normalized() * (self.Radius + target.Radius)
	self.Velocity = vector.new(0, 0)
	self.HealthDrainRate = 1
end

function e_proj_sticky_bomb:on_collision(world, target, mtv)
	if not self.stuck then
		self.stuck = true
		self:stick(target, mtv)
	end
end

function e_proj_sticky_bomb:on_arena_collision(world, pos, side)
	self.Velocity = vector.new(0, 0)
	self.HealthDrainRate = 1
end

---

return e_proj_sticky_bomb
