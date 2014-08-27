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
		{
			event = "EntityDead",
			func = function(world, entity)
				world:destroyEntity(entity)
			end
		}
	}
}
