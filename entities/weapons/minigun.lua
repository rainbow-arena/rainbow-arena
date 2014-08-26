local util = require("lib.self.util")

local map = util.math.map

local bullet = require("entities.projectiles.bullet")
local proj_weapon = require("entities.weapons.base_projectile")

local ss_cooldown_ratio = 0.2

return function(projectile_prototype, projectile_speed, start_cooldown, end_cooldown, spinup_time)
	local minigun = proj_weapon(projectile_prototype, projectile_speed)

	minigun.type = "repeat"

	---

	function minigun:fire_start(world, host, pos, dir)
		self.cooldown = start_cooldown
		self.firetime = 0

		self.ss_ent = world:spawnEntity{
			Position = host.Position:clone(),

			Screenshake = {
				intensity = 0,
				radius = 100
			}
		}
	end

	function minigun:firing(host, world, dt, pos, dir)
		self.firetime = self.firetime + dt
		if self.firetime > spinup_time then
			self.firetime = spinup_time
		end

		self.cooldown = map(self.firetime, 0,spinup_time, start_cooldown,end_cooldown)

		self.ss_ent.Position = host.Position:clone()
		self.ss_ent.Screenshake.intensity = ss_cooldown_ratio / self.cooldown
	end

	function minigun:fire_end(host, world)
		world:destroyEntity(self.ss_ent)
	end

	function minigun:get_cooldown()
		return self.cooldown
	end

	return minigun
end

