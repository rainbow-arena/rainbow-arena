local vector = require("lib.hump.vector")

local img_particle = love.graphics.newImage("graphics/particle.png")

return function(pos, radius, force, damage, color, lifetime, nparticles)
	local ps = love.graphics.newParticleSystem(img_particle, 1024)
	local pradius = radius + 50

	local exp_r, exp_g, exp_b = unpack(color or {255, 97, 0})
	local lifetime = lifetime or 2

	ps:setPosition(pos:unpack()) -- Where to emit.
	ps:setEmitterLifetime(0.1) -- How long to emit for.
	ps:setParticleLifetime(0.1, lifetime) -- How long particles last.
	ps:setEmissionRate(100) -- Particles emitted per second.
	ps:setSpeed(10, pradius/lifetime) -- Speed of particles.
	ps:setSpread(2 * math.pi) -- Spread in all directions.
	ps:setAreaSpread("normal", pradius/50, pradius/50) -- Initial spread.
	ps:setColors(exp_r, exp_g, exp_b, 255, exp_r, exp_g, exp_b, 0) -- Particle color tween.
	ps:setSizes(1, 0) -- Particle size tween.
	ps:setSizeVariation(1)

	ps:start()
	ps:emit(nparticles or 512)

	return {
		Position = pos:clone(),

		Lifetime = lifetime,

		ParticleSystem = ps,

		Explosion = {
			force = force,
			damage = damage,
			radius = radius
		}
	}
end
