local img_particle = love.graphics.newImage("graphics/particle.png")

return function(pos, radius, force, damage, color)
	local ps = love.graphics.newParticleSystem(img_particle, 1024)

	local exp_r, exp_g, exp_b = color[1] or 255, color[2] or 97, color[3] or 0

	ps:setPosition(ax, ay)
	ps:setEmitterLifetime(0.1)
	ps:setParticleLifetime(0.1,3)
	ps:setEmissionRate(100)
	ps:setSpeed(10, 100)
	ps:setSpread(2 * math.pi)
	ps:setAreaSpread("normal", radius/4, radius/4)
	ps:setColors(sr, sg, sb, 255, sr, sg, sb, 0)
	ps:setSizes(1, 0)
	ps:setSizeVariation(1)
	ps:start()
	ps:emit(512)

	local explosion = {
		Position = vector.new(x, y),

		Lifetime = 3,

		ParticleSystem = ps,

		Explosion = {
			force = 2*10^6,
			damage = 10,
			radius = radius
		}
	}
end
