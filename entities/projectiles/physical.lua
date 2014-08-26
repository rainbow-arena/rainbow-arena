local class = require("lib.hump.class")

local weaponutil = require("util.weapon")

---

local e_proj_generic = require("entities.projectiles.generic")
local e_proj_physical = class{__includes = e_proj_generic}

function e_proj_physical:init(arg)
	arg = arg or {}

	self.Radius = arg.radius or 3
	self.Mass = arg.mass or math.pi * self.Radius^2
	self.Color = arg.color or {255, 255, 0}

	e_proj_generic.init(self)
end

function e_proj_physical:on_collision(world, target, mtv)
	-- Apply impact force.
	target.Velocity = weaponutil.calculate_post_impact_velocity(
		self.Mass, self.Velocity, target.Mass, target.Velocity)

	e_proj_generic.on_collision(self, world, target, mtv)
end

return e_proj_physical
