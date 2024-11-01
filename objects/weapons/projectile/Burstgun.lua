--- Require ---
local Class = require("lib.hump.class")

local util = require("lib.util")
--- ==== ---


--- Classes ---
local wep_Projectile = require("objects.weapons.projectile.Projectile")
local ret_CircleReticle = require("objects.weapons.components.reticles.CircleReticle")
--- ==== ---


--- Class definition ---
local wep_Burstgun = Class{__includes = wep_Projectile}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_Burstgun:init(args)
    assert(util.table.check(args, {
        "shotPellets", -- How many projectiles are fired per shot.
        "shotBurstDelay" -- Time between burst shots.
    }, "wep_Burstgun"))

    self.shotPellets = args.shotPellets
    self.shotBurstDelay = args.shotBurstDelay

    self._burst_firing = false

    return wep_Projectile.init(self, args)
end

---

function wep_Burstgun:firing(world, wielder)
    if self:can_fire() then
        self.timer:script(function(wait)
            self._burst_firing = true

            local proj
            for i = 1, self.shotPellets do
                proj = self:shot_fire_projectile(world, wielder)

                self:shot_add_heat()

                self:shot_play_sound(world, proj.Position:clone())
                self:shot_apply_screenshake(world, wielder.Position:clone())

                wait(self.shotBurstDelay)
            end

            self:shot_add_delay()
            self._burst_firing = false
        end)
    end

    wep_Projectile.fire_begin(self, world, wielder)
end

function wep_Burstgun:can_fire()
    return wep_Projectile.can_fire(self) and not self._burst_firing
end

---

function wep_Burstgun:draw_reticle()
    ret_CircleReticle.draw()
end
--- ==== ---


return wep_Burstgun
