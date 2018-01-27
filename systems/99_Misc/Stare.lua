--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- System ---
local sys_Stare = Class(tiny.processingSystem())
sys_Stare.filter = tiny.requireAll("DesiredAimAngle", "StareAt")
--- ==== ---


--- Constants ---
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Stare:process(e, dt)
    local world = self.world.world

    local target = e.StareAt
    e.AimVector = target.Position - e.Position
end
--- ==== ---

return sys_Stare
