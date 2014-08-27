return {
	systems = {
		{
			name = "UpdateParticleSystem",
			requires = {"ParticleSystem"},
			update = function(entity, world, dt)
				local ps = entity.ParticleSystem
				ps:moveTo(entity.Position:unpack())
				ps:update(dt)
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
