local class = require("lib.hump.class")
local vector = require("lib.hump.vector")

---

local img_particle = love.graphics.newImage("graphics/particle.png")

local e_explosion = class{}

function e_explosion:init(arg)
	assert(arg.position, "Explosion init missing fields!")

	local radius = arg.radius or 200
	local pradius = radius + 70
	local color = arg.color or {255, 97, 0}
	local duration = arg.duration or 1
	local speed = pradius/duration

	local ps = love.graphics.newParticleSystem(arg.particle_img or img_particle, 1024)
	ps:setPosition(arg.position:unpack()) -- Where to emit.
	ps:setEmitterLifetime(0.1) -- How long to emit for.
	ps:setParticleLifetime(0.1, duration) -- How long particles last.
	ps:setEmissionRate(100) -- Particles emitted per second.
	ps:setSpeed(10, speed) -- Speed of particles.
	ps:setSpread(2 * math.pi) -- Spread in all directions.
	ps:setAreaSpread("normal", pradius/50, pradius/50) -- Initial spread.
	ps:setColors(color[1], color[2], color[3], 255, color[1], color[2], color[3], 0) -- Particle color tween.
	ps:setSizes(1, 0) -- Particle size tween.
	ps:setSizeVariation(1)

	ps:start()
	ps:emit(arg.particles or 768)

	self.Position = arg.position:clone()
	self.Lifetime = duration
	self.ParticleSystem = ps
	self.Explosion = {
		radius = radius,
		speed = speed,
		force = arg.force or 2*10^6,
		damage = arg.damage or 10,
	}
	self.Screenshake = {
		intensity = arg.screenshake or 3,
		radius = radius,
		duration = duration
	}
end

---

return e_explosion
