--- Require ---
local Class = require("lib.hump.class")
--- ==== ---


--- Classes ---
--- ==== ---


--- Class definition ---
local wep_Base = Class{}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_Base:init(args)

end


-- Weapon callbacks --
-- Called once when the combatant begins firing, ie. when they press the fire button.
function wep_Base:fire_begin(world, wielder)

end

-- Called once per frame while the combatant is firing, ie. when the fire button is being held
-- EXCEPT the frames :fire_begin() and :fire_end() are called.
function wep_Base:firing(world, wielder, dt)

end

-- Called once when the combatant ceases firing, ie. when they release the fire button.
function wep_Base:fire_end(world, wielder)

end

-- Called once per frame, always.
function wep_Base:update(world, wielder, dt)

end
-- ==== --


-- Other --
-- NOTE: Reticles are drawn immediate mode.
function wep_Base:draw_reticule()

end
-- ==== --
--- ==== ---


return wep_Base
