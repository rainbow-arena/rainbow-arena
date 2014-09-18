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

	self.detonate_delay = arg.detonate_delay or 3

	e_proj_bomb.init(self, arg)
end

function e_proj_sticky_bomb:on_collision(world, target, mtv)
	if not self.stuck then
		local offset = self.Position - target.Position
		self.AttachedTo = target
		self.AttachmentOffset = offset
		self.Velocity = vector.new(0, 0)

		self.stuck = true
		world.timer:add(self.detonate_delay, function()
			e_proj_bomb.on_collision(self, world, target, mtv)
		end)
	end
end

function e_proj_sticky_bomb:on_arena_collision(world, pos, side)
	e_proj_bomb.on_arena_collision(self, world, pos, side)
end

---

return e_proj_sticky_bomb
