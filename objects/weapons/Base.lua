--- Require ---
local Class = require("lib.hump.class")
local timer = require("lib.hump.timer")

local util = require("lib.util")
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
	assert(util.table.check(args, {
		"heatLimit", -- The maximum heat before overheat.
	}, "wep_Base"))

	self.heat = 0
	self.heatLimit = args.heatLimit
	self.overheat = false

	self.timer = timer.new()
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
-- THOUGHT: Should the numbers be updated before or after the check?
function wep_Base:update(world, wielder, dt)
	-- Heat/overheat.
	if self.heat > self.heatLimit then
		self.overheat = true
	elseif self.heat <= 0 then
		self.overheat = false
		self.heat = 0
	end
	self.heat = self.heat - dt

	-- Timer.
	self.timer:update(dt)
end
-- ==== --


-- Other --
function wep_Base:can_fire_heat()
	return not self.overheat
end

function wep_Base:can_fire()
	return self:can_fire_heat()
end

---

function wep_Base:draw_reticule()

end
-- ==== --
--- ==== ---


return wep_Base
