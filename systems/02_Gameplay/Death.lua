--- Require ---
local Class = require("lib.hump.class")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- Classes ---
local ent_Explosion = require("entities.Explosion")
--- ==== ---


--- System ---
local sys_Death = Class(tiny.processingSystem())
sys_Death.filter = tiny.requireAll("Health")
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Death:onAddToWorld(world)
	local world = world.world

	world:register_event("EntityDied", function(world, e)
		if e.ExplodeOnDeath and e.Position and e.Radius then
			-- TODO: Make death explosion configurable.
			world:add_entity(ent_Explosion{
				Position = e.Position:clone(),
				Color = e.Color,
				force = 2 * 10^5 * e.Radius,
				damage = e.Radius * 8,
				radius = 10 * e.Radius/1.5,
				duration = 2
			})
		end
	end)

end

function sys_Death:process(e, dt)
	local world = self.world.world

	if e.Health.current < 0 then
		world:emit_event("EntityDied", e)
		world:remove_entity(e)
	end
end
--- ==== ---

return sys_Death
