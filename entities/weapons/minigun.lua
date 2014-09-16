local class = require("lib.hump.class")
local util = require("lib.self.util")

---

local map = util.math.map

---

local w_projectile = require("entities.weapons.projectile")
local w_minigun = class{__includes = w_projectile}

function w_minigun:init(arg)
	self.start_shot_delay = arg.start_shot_delay or 0.3
	self.final_shot_delay = arg.final_shot_delay or 0.05
	self.spinup_time = arg.spinup_time or 2

	arg.kind = "repeat"

	w_projectile.init(self, arg)
end

function w_minigun:start(host, world, pos, dir)
	self.shot_delay = self.start_shot_delay
	self.firetime = 0

	w_projectile.start(self, host, world, pos, dir)
end

function w_minigun:firing(dt, host, world, pos, dir)
	self.firetime = self.firetime + dt
	if self.firetime > self.spinup_time then
		self.firetime = self.spinup_time
	end

	self.shot_delay = map(self.firetime, 0,self.spinup_time, self.start_shot_delay,self.final_shot_delay)

	self:set_screenshake(0.2 / self.shot_delay)

	w_projectile.firing(self, dt, host, world, pos, dir)
end

---

return w_minigun
