return {
	systems = {
		{
			name = "DieOnNoHealth",
			requires = {"Health"},
			update = function(entity, world)
				if entity.Health <= 0 then
					world:emitEvent("EntityDead", entity)
				end
			end
		}
	},

	events = {
		{ -- Placeholder for now. TODO: Fancy death graphics.
			event = "EntityDead",
			func = function(world, entity)
				world:destroyEntity(entity)
			end
		}
	}
}
