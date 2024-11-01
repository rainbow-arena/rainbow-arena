--- Require ---
local Class = require("lib.hump.class")

local util = require("lib.util")
--- ==== ---


--- Classes ---
local wep_Projectile = require("objects.weapons.projectile.Projectile")
local ret_CircleReticle = require("objects.weapons.components.reticles.CircleReticle")
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

        "spinupTime" -- Time it takes to get to full firerate.
    }, "wep_Minigun"))

    args.shotSound = "assets/audio/laser_shot.wav"

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

    -- self:can_fire() handles shot delay, so we don't have to manually here.
    if self:can_fire() then
        local proj = self:shot_fire_projectile(world, wielder)

        self:shot_add_delay()
        self:shot_add_heat()

        self:shot_play_sound(world, proj.Position:clone())
        self:shot_apply_screenshake(world, wielder.Position:clone())
    end

    wep_Projectile.firing(self, world, wielder, dt)
end

---

function wep_Minigun:draw_reticle()
    ret_CircleReticle.draw()
end
--- ==== ---


return wep_Minigun
