--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")
--- ==== ---


-- Note: Firing is determined by component: `Firing`


--- System ---
local sys_Weapon = tiny.processingSystem()
sys_Weapon.filter = tiny.requireAll("Weapon", "AimAngle") -- TODO: Weapons which aren't aimed?
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Weapon:process(e, dt)

end
--- ==== ---

return Class(sys_Weapon)
