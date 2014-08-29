local class = require("lib.hump.class")
local weaponutil = require("util.weapon")
local util = require("lib.self.util")

local clone = util.table.clone

local w_base = require("entities.weapons.base")
local weapon = class{__includes = w_base}

---

function weapon:init(arg)
	self.kind = arg.kind or "single"
	self.shot_heat = arg.shot_heat or 0.25
	self.projectile = arg.projectile
	self.projectile_speed = arg.projectile_speed or 800
	self.shot_delay = arg.shot_delay or 0.1

	self.shot_timer = 0

	w_base.init(self, arg)
end

---

function weapon:spawn_projectile(host, world, pos, dir)
	local projectile = clone(self.projectile)
	projectile.Position = pos + dir
	projectile.Velocity = self.projectile_speed * dir + host.Velocity
	projectile.Team = host.Team

	-- Add host to collision exclusion list.
	if not projectile.CollisionExcludeEntities then
		projectile.CollisionExcludeEntities = {host}
	else
		table.insert(projectile.CollisionExcludeEntities, host)
	end

	world:spawnEntity(projectile)

	return projectile
end

function weapon:apply_recoil(host, projectile, dir)
	if not projectile.Mass then
		projectile.Mass = math.pi * projectile.Radius^2
	end

	host.Velocity = weaponutil.calculate_recoil_velocity(projectile.Mass,
		self.projectile_speed * dir, host.Mass, host.Velocity)
end

function weapon:fire(host, world, pos, dir)
	local p = self:spawn_projectile(host, world, pos, dir)
	self:apply_recoil(host, p, dir)
	self.shot_timer = self.shot_delay
	self.heat = self.heat + self.shot_heat

	host.ColorPulse = 1
end

---

function weapon:start(host, world, pos, dir)
	w_base.start(self, host, world, pos, dir)
end

function weapon:firing(dt, host, world, pos, dir)
	if self.shot_timer == 0 then
		if (self.kind == "single" and not self.fired) or self.kind ~= "single" then
			self.fired = true
			self:fire(host, world, pos, dir)
		end
	end

	w_base.update(self, host, world, pos, dir)
end

function weapon:cease(host, world)
	self.fired = false

	w_base.cease(self, host, world)
end

function weapon:update(dt, host, world)
	self.shot_timer = self.shot_timer - dt
	if self.shot_timer < 0 then
		self.shot_timer = 0
	end
end

return weapon
