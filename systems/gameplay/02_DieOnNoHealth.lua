--- Require ---
local Class = require("lib.hump.class")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- Classes ---
local ent_Explosion = require("entities.Explosion")
--- ==== ---


--- System definition ---
local sys_DieOnNoHealth = tiny.processingSystem()
sys_DieOnNoHealth.filter = tiny.requireAll("Health")
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_DieOnNoHealth:onAddToWorld(world)
	local world = world.world

	world:register_event("EntityDied", function(world, e)
		if e.ExplodeOnDeath and e.Position and e.Radius then
			-- TODO: Make death explosion configurable.
			world:add_entity(ent_Explosion{
				position = e.Position:clone(),
				color = e.Color,
				force = 10^4 * e.Radius,
				damage = e.Radius/10,
				radius = e.Radius/1.5 * 10,
				duration = 2
			})
		end
	end)

end

function sys_DieOnNoHealth:process(e, dt)
	local world = self.world.world

	if e.Health.current < 0 then
		world:emit_event("EntityDied", e)
		world:remove_entity(e)
	end
end
--- ==== ---

return Class(sys_DieOnNoHealth)
