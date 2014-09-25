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
		},

		{
			name = "DoHealthDrain",
			requires = {"Health", "HealthDrainRate"},
			update = function(entity, world, dt)
				entity.Health = entity.Health - entity.HealthDrainRate*dt
			end
		}
	},

	events = {
		{
			event = "EntityDead",
			func = function(world, entity)
				-- Add an explosion!
				if entity.DeathExplosion and entity.Position then
					local expdata = (type(entity.DeathExplosion) == "table")
						and entity.DeathExplosion or {}

					world:spawn_entity(require("entities.effects.explosion"){
						position = entity.Position,
						color = expdata.color or entity.Color,
						force = expdata.force or 5*10^5,
						damage = expdata.damage or 5,
						radius = expdata.radius or (entity.Radius or 30)/1.5 * 10,
						screenshake = expdata.screenshake or 1,
						duration = expdata.duration or 2
					})
				end
			end
		},
		{
			event = "EntityDead",
			func = function(world, entity)
				if entity.OnDeath then
					entity:OnDeath(world)
				end
				world:destroy_entity(entity)
			end
		},
	}
}
