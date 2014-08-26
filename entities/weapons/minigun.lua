local class = require("lib.hump.class")
local util = require("lib.self.util")

local map = util.math.map

local w_projectile = require("entities.weapons.projectile")
local weapon = class{__includes = w_projectile}

function weapon:init(maxheat, shot_heat, projectile, projectile_speed,
	start_shot_delay, final_shot_delay, spinup_time, shake_radius)

	self.start_shot_delay = start_shot_delay
	self.final_shot_delay = final_shot_delay
	self.spinup_time = spinup_time
	self.shake_radius = self.shake_radius or 100

	w_projectile.init(self, maxheat, shot_heat, "repeat", projectile, projectile_speed, start_shot_delay)
end

function weapon:start(host, world, pos, dir)
	self.shot_delay = self.start_shot_delay
	self.firetime = 0

	self.ss = world:spawnEntity{
		Position = host.Position:clone(),

		Screenshake = {
			intensity = 0,
			radius = self.shake_radius
		}
	}

	w_projectile.start(self, host, world, pos, dir)
end

function weapon:update(dt, host, world, pos, dir)
	self.firetime = self.firetime + dt
	if self.firetime > self.spinup_time then
		self.firetime = self.spinup_time
	end

	self.shot_delay = map(self.firetime, 0,self.spinup_time, self.start_shot_delay,self.final_shot_delay)

	self.ss.Position = host.Position:clone()
	self.ss.Screenshake.intensity = 0.2 / self.shot_delay

	w_projectile.update(self, dt, host, world, pos, dir)
end

function weapon:cease(host, world)
	world:destroyEntity(self.ss)

	w_projectile.cease(self, host, world)
end

return weapon
