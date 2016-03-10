--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")

local angle = require("util.angle")
--- ==== ---


--- Classes ---
local wep_Base = require("weapons.Base")
--- ==== ---


--- Class definition ---
local wep_Projectile = Class{__includes = wep_Base}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_Projectile:init(args)
	assert(util.table.check(args, {
		"projectile", -- Projectile entity template
		"muzzleVelocity",
		"spread", -- Maximum bullet spread in radians
	}, "wep_Projectile"))

	self.projectile = args.projectile
	self.muzzleVelocity = args.muzzleVelocity
	self.spread = args.spread

	return wep_Base.init(self, args)
end


---

function wep_Projectile:fire_projectile(world, wielder)
	local wielder_facing_vec = angle.angle_to_vector(wielder.AimAngle)

	local shot_spread_angle = (love.math.random() - 0.5) * self.spread
	local shot_spread_dir_vec = angle.angle_to_vector(wielder.AimAngle + shot_spread_angle)

	local muzzle_length = self.projectile.Radius or 0

	local firing_from_vec = wielder.Position + wielder_facing_vec * ((wielder.Radius or 0) + muzzle_length)

	---

	local proj = world:add_entity(Class.clone(self.projectile))

	proj.Position = firing_from_vec

	-- TODO: Why is this needed?
	proj.Velocity = vector.new(0, 0)

	---

	local shot_force_duration = 0.0001
	local shot_force_vector = shot_spread_dir_vec *
		(proj.Mass * (self.muzzleVelocity / shot_force_duration)) -- f = m * (v / t)

	table.insert(proj.Forces, {vector = shot_force_vector, duration = shot_force_duration})
	table.insert(wielder.Forces, {vector = -shot_force_vector, duration = shot_force_duration})

	return proj
end

---

function wep_Projectile:fire_begin(world, wielder)

end

function wep_Projectile:firing(world, wielder, dt)

end

function wep_Projectile:fire_end(world, wielder)

end

function wep_Projectile:update(world, wielder, dt)

end
--- ==== ---


return wep_Projectile
