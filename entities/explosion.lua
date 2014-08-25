local vector = require("lib.hump.vector")

local img_particle = love.graphics.newImage("graphics/particle.png")

return function(pos, radius, force, damage, color, duration, nparticles, screenshake)
	local ps = love.graphics.newParticleSystem(img_particle, 1024)
	local pradius = radius + 70

	local exp_r, exp_g, exp_b = unpack(color or {255, 97, 0})

	duration = duration or 1
	speed = speed or pradius/duration

	ps:setPosition(pos:unpack()) -- Where to emit.
	ps:setEmitterLifetime(0.1) -- How long to emit for.
	ps:setParticleLifetime(0.1, duration) -- How long particles last.
	ps:setEmissionRate(100) -- Particles emitted per second.
	ps:setSpeed(10, speed) -- Speed of particles.
	ps:setSpread(2 * math.pi) -- Spread in all directions.
	ps:setAreaSpread("normal", pradius/50, pradius/50) -- Initial spread.
	ps:setColors(exp_r, exp_g, exp_b, 255, exp_r, exp_g, exp_b, 0) -- Particle color tween.
	ps:setSizes(1, 0) -- Particle size tween.
	ps:setSizeVariation(1)

	ps:start()
	ps:emit(nparticles or 768)

	return {
		Position = pos:clone(),

		Lifetime = duration,

		ParticleSystem = ps,

		Explosion = {
			radius = radius,
			speed = speed,
			force = force,
			damage = damage,
		},

		Screenshake = {
			intensity = screenshake or 3,
			radius = radius,
			duration = duration/2
		}
	}
end
