return {
	systems = {
		{
			name = "UpdateParticleSystem",
			requires = {"ParticleSystem"},
			update = function(entity, world, dt)
				entity.ParticleSystem:setPosition(entity.Position:unpack())
				entity.ParticleSystem:update(dt)
			end
		},
		{
			name = "DrawParticleSystem",
			requires = {"ParticleSystem"},
			draw = function(entity, world, dt)
				love.graphics.draw(entity.ParticleSystem)
			end
		}
	}
}
