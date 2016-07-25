-- Abstract class for projectile weapons.
-- Provides the methods for firing projectiles and delay between that, but
-- doesn't use them.


--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")

local angleutil = require("util.angle")
local entutil = require("util.entity")
--- ==== ---


--- Classes ---
local wep_Base = require("weapons.Base")

local ent_Sound = require("entities.Sound")
local ent_Screenshake = require("entities.Screenshake")
--- ==== ---


--- Class definition ---
local wep_Projectile = Class{__includes = wep_Base}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_Projectile:init(args)
	assert(util.table.check(args, {
		"projectile", -- Projectile entity template.

		"muzzleVelocity",
		"spread", -- Maximum bullet spread in radians.

		"shotDelay", -- Time between shots.

		"shotHeat", -- How much heat (in seconds) each shot adds.
	}, "wep_Projectile"))

	self.projectile = args.projectile
	self.muzzleVelocity = args.muzzleVelocity
	self.spread = args.spread

	self.shotDelay = args.shotDelay
	self.shotDelayTimer = 0

	self.shotHeat = args.shotHeat

	if args.shotSound then
		self.shotSound = args.shotSound
	end

	if args.screenshake then
		self.screenshake = args.screenshake
		self.screenshake.removeOnFinish = true
	end

	return wep_Base.init(self, args)
end

---

function wep_Projectile:shot_fire_projectile(world, wielder, muzzle_offset)
	local wielder_facing_vec = angleutil.angle_to_vector(wielder.AimAngle)

	local shot_spread_angle = (love.math.random() - 0.5) * self.spread
	local shot_spread_dir_vec = angleutil.angle_to_vector(wielder.AimAngle + shot_spread_angle)

	local muzzle_length = self.projectile.Radius or 0

	local firing_from_vec = wielder.Position + wielder_facing_vec * ((wielder.Radius or 0) + muzzle_length)

	---

	local proj = world:add_entity(entutil.clone(self.projectile))

	proj.Position = firing_from_vec

	---

	local shot_force_duration = 0.0001
	local shot_force_vector = shot_spread_dir_vec *
		(proj.Mass * (self.muzzleVelocity / shot_force_duration)) -- f = m * (v / t)

	table.insert(proj.Forces, {vector = shot_force_vector, duration = shot_force_duration})
	table.insert(wielder.Forces, {vector = -shot_force_vector, duration = shot_force_duration})
	proj.hitForce = {vector = shot_force_vector, duration = shot_force_duration}

	---

	return proj
end

function wep_Projectile:shot_add_delay()
	self.shotDelayTimer = self.shotDelay
end

function wep_Projectile:shot_add_heat()
	self.heat = self.heat + self.shotHeat
end

function wep_Projectile:shot_play_sound(world, position)
	if self.shotSound then
		 local sound_ent = ent_Sound{
			Position = position,
			soundpath = self.shotSound
		 }

		 world:add_entity(sound_ent)
	end
end

function wep_Projectile:shot_apply_screenshake(world, position)
	-- TODO
end

---

function wep_Projectile:can_fire_shot_delay()
	return self.shotDelayTimer <= 0
end

---

function wep_Projectile:can_fire()
	return wep_Base.can_fire(self) and self:can_fire_shot_delay()
end

-- THOUGHT: Should the numbers be updated before or after the check?
function wep_Projectile:update(world, wielder, dt)
	-- Shot delay.
	if self.shotDelayTimer < 0 then self.shotDelayTimer = 0 end
	self.shotDelayTimer = self.shotDelayTimer - dt

	wep_Base.update(self, world, wielder, dt)
end
--- ==== ---


return wep_Projectile
