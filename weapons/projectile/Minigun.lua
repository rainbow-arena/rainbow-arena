--- Require ---
local Class = require("lib.hump.class")

local util = require("lib.util")
--- ==== ---


--- Classes ---
local wep_Projectile = require("weapons.projectile.Projectile")
local ret_DotReticle = require("weapons.components.reticles.DotReticle")
--- ==== ---


--- Class definition ---
local wep_Minigun = Class{__includes = wep_Projectile}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_Minigun:init(args)
	assert(util.table.check(args, {
		"initialShotDelay", -- Time between shots initially.
		"finalShotDelay", -- Time between shots after the spinup time.

		"spinupTime"
	}, "wep_Minigun"))

	args.shotSound = "audio/weapons/laser_shot.wav"

	args.shotDelay = args.initialShotDelay

	self.initialShotDelay = args.initialShotDelay
	self.finalShotDelay = args.finalShotDelay

	self.spinupTime = args.spinupTime
	self.spinupTimer = 0

	return wep_Projectile.init(self, args)
end

---

function wep_Minigun:fire_begin(world, wielder)
	self.shotDelay = self.initialShotDelay
	self.spinupTimer = 0

	wep_Projectile.fire_begin(self, world, wielder)
end

function wep_Minigun:firing(world, wielder, dt)
	self.spinupTimer = self.spinupTimer + dt
	if self.spinupTimer > self.spinupTime then
		self.spinupTimer = self.spinupTime
	end

	self.shotDelay = util.math.map(self.spinupTimer,
		0,self.spinupTime, self.initialShotDelay, self.finalShotDelay)

	if self:can_fire() then
		local proj = self:shot_fire_projectile(world, wielder)

		self:shot_add_delay()
		self:shot_add_heat()

		self:shot_play_sound(world, proj.Position:clone())
		self:shot_apply_screenshake(world, wielder.Position:clone())
	end

	wep_Projectile.firing(self, world, wielder, dt)
end

function wep_Minigun:fire_end(world, wielder)
	wep_Projectile.fire_end(self, world, wielder)
end

function wep_Minigun:update(world, wielder, dt)
	wep_Projectile.update(self, world, wielder, dt)
end

---

function wep_Minigun:draw_reticle()
	ret_DotReticle.draw()
end
--- ==== ---


return wep_Minigun
