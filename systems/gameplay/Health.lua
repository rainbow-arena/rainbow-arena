return {
	systems = {
		{
			name = "DieOnNoHealth",
			requires = {"Health"},
			update = function(entity, world)
				if entity.Health <= 0 then
					world:emit_event("EntityDead", entity)
				end
			end
		}
	},

	events = {
		{
			event = "EntityDead",
			func = function(world, entity)
				-- Add an explosion!
				if entity.Position then
					world:spawn_entity(require("entities.effects.explosion"){
						position = entity.Position,
						color = entity.Color,
						force = 5*10^5,
						damage = 5,
						radius = (entity.Radius or 30)/1.5 * 10,
						screenshake = 1,
						duration = 2
					})
				end
			end
		},
		{
			event = "EntityDead",
			func = function(world, entity)
				world:destroy_entity(entity)
			end
		},
	}
}
