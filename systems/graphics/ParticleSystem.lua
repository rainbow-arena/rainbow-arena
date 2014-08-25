return {
	systems = {
		{
			name = "UpdateParticleSystem",
			requires = {"ParticleSystem"},
			update = function(entity, world, dt)
				if entity.ParticleSystem:getCount() == 0 then
					entity.ParticleSystem = nil
				else
					entity.ParticleSystem:update(dt)
				end
			end
		},
		{
			name = "DrawParticleSystem",
			requires = {"ParticleSystem"},
			draw = function(entity, world, dt)
				love.graphics.draw(entity.ParticleSystem, entity.Position.x, entity.Position.y)
			end
		}
	}
}
