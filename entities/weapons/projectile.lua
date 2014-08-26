local class = require("lib.hump.class")
local weaponutil = require("util.weapon")
local util = require("lib.self.util")

local join = util.table.join

local w_base = require("entities.weapons.base")
local weapon = class{__includes = w_base}

---

function weapon:init(maxheat, shot_heat, kind, projectile, projectile_speed, shot_delay)
	self.kind = kind or "single"
	self.shot_heat = shot_heat
	self.projectile = projectile
	self.projectile_speed = projectile_speed
	self.shot_delay = shot_delay

	self.shot_timer = 0

	w_base.init(self, maxheat)
end

---

function weapon:spawn_projectile(world, host, pos, dir)
	local projectile = world:spawnEntity(
		util.table.join(
			self.projectile,
			{
				Position = pos + dir,
				Velocity = self.projectile_speed * dir + host.Velocity,
				Team = host.Team
			}
		)
	)

	-- Add host to collision exclusion list.
	if not projectile.CollisionExcludeEntities then
		projectile.CollisionExcludeEntities = {host}
	else
		table.insert(projectile.CollisionExcludeEntities, host)
	end

	return projectile
end

function weapon:apply_recoil(projectile, host, dir)
	if not projectile.Mass then
		projectile.Mass = math.pi * projectile.Radius^2
	end

	host.Velocity = weaponutil.calculate_recoil_velocity(projectile.Mass,
		self.projectile_speed * dir, host.Mass, host.Velocity)
end

function weapon:fire(world, host, pos, dir)
	local p = self:spawn_projectile(world, host, pos, dir)
	self:apply_recoil(p, host, dir)
	self.shot_timer = self.shot_delay
	self.heat = self.heat + self.shot_heat
end

---

function weapon:start(world, host, pos, dir)
	w_base.start(self, world, host, pos, dir)
end

function weapon:update(dt, host, world, pos, dir)
	self.shot_timer = self.shot_timer - dt
	if self.shot_timer < 0 then
		self.shot_timer = 0

		if (self.kind == "single" and not self.fired) or self.kind ~= "single" then
			self.fired = true
			self:fire(world, host, pos, dir)
		end
	end

	w_base.update(self, world, host, pos, dir)
end

function weapon:cease(world, host)
	self.fired = false

	w_base.cease(self, world, host)
end

return weapon
