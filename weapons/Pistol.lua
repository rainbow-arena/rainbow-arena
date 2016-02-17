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
local wep_Pistol = Class{__includes = wep_Base}
--- ==== ---


--- Local functions ---
local function fire_projectile(world, proj_template, from_vec, from_vel, dir_vec, vel)
	local proj = world:add_entity(Class.clone(proj_template))

	dir_vec = dir_vec:normalized()

	proj.Position = from_vec:clone()
	proj.Velocity = dir_vec * vel + (from_vel or vector.zero)
	proj.Drag = 0
	proj.CollisionPhysics = true

	return proj
end
--- ==== ---


--- Class functions ---
function wep_Pistol:init(args)
	assert(util.table.check(args, {
		"projectile", -- Projectile entity template
		"muzzleVelocity",
		"spread", -- Maximum bullet spread in radians
		"cooldown" -- In seconds
	}, "Pistol"))

	self.projectile = args.projectile
	self.muzzleVelocity = args.muzzleVelocity
	self.spread = args.spread
	self.cooldown = args.cooldown

	self.heat = 0

	return wep_Base.init(self, args)
end


-- Weapon callbacks --
function wep_Pistol:fire_begin(world, wielder)
	if self.heat == 0 then
		local dir_vec = angle.angle_to_vector(wielder.AimAngle)

		local spread_angle = (love.math.random() * self.spread) - self.spread/2
		local spread_dir_vec = angle.angle_to_vector(wielder.AimAngle + spread_angle)

		local muzzle_length = self.projectile.Radius or 0

		fire_projectile(world, self.projectile,
			wielder.Position + dir_vec * ((wielder.Radius or 0) + muzzle_length),
			wielder.Velocity,
			spread_dir_vec, self.muzzleVelocity)

		self.heat = self.cooldown
	end
end

function wep_Pistol:firing(world, wielder, dt)

end

function wep_Pistol:fire_end(world, wielder)

end

function wep_Pistol:update(world, wielder, dt)
	self.heat = self.heat - dt
	if self.heat < 0 then
		self.heat = 0
	end
end
-- ==== --
--- ==== ---


return wep_Pistol
