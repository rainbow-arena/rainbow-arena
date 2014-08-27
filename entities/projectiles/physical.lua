local class = require("lib.hump.class")

local weaponutil = require("util.weapon")

---

local e_proj_base = require("entities.projectiles.base")
local e_proj_physical = class{__includes = e_proj_base}

function e_proj_physical:init(arg)
	arg = arg or {}

	self.Radius = arg.radius or 3
	self.Mass = arg.mass or math.pi * self.Radius^2
	self.Color = arg.color or {255, 255, 0}

	e_proj_base.init(self)
end

function e_proj_physical:on_collision(world, target, mtv)
	-- Apply impact force.
	target.Velocity = weaponutil.calculate_post_impact_velocity(
		self.Mass, self.Velocity, target.Mass, target.Velocity)

	if target.Color then target.ColorPulse = 1 end

	e_proj_base.on_collision(self, world, target, mtv)
end

return e_proj_physical
