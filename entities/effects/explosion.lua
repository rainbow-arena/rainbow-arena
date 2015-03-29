local class = require("lib.hump.class")
local vector = require("lib.hump.vector")
local util = require("lib.self.util")

---

local has = util.table.has

---

local img_particle = love.graphics.newImage("graphics/particle.png")

local e_explosion = class{}

function e_explosion:init(arg)
	assert(has(arg, {
		"position",
		"radius",
		"duration"
	}))


	local color = arg.color or {255, 97, 0}
	local particle_speed = (arg.radius/arg.duration) / 2

	---

	local ps = love.graphics.newParticleSystem(img_particle, 1024)
	ps:setPosition(arg.position:unpack()) -- Where to emit.
	ps:setEmitterLifetime(0.1) -- How long to emit for.
	ps:setParticleLifetime(0.1, arg.duration) -- How long particles last.
	ps:setEmissionRate(100) -- Particles emitted per second.
	ps:setSpeed(10, particle_speed) -- Speed of particles.
	ps:setSpread(2 * math.pi) -- Spread in all directions.

	local area_spread = arg.radius/50
	ps:setAreaSpread("normal", area_spread, area_spread) -- Initial spread.
	ps:setColors(color[1], color[2], color[3], 255, color[1], color[2], color[3], 0) -- Particle color tween.
	ps:setSizes(1, 0) -- Particle size tween.
	ps:setSizeVariation(1)

	ps:start()
	ps:emit(arg.n_particles or 768)

	---

	self.Position = arg.position:clone()
	self.Lifetime = duration
	self.ParticleSystem = ps

	self.Blast = {
		radius = arg.radius,
		duration = arg.duration,
		func = function(entity, impact, dir_vec)
			-- Flash entity.
			if entity.Color then entity.ColorPulse = impact end

			-- Apply explosion force.
			if entity.CollisionPhysics and entity.Velocity then
				entity.Velocity = entity.Velocity + impact * ((arg.force or 10^6) / entity.Mass) * dir_vec
			end

			-- Apply health damage.
			if entity.Health and arg.damage then
				entity.Health = entity.Health - math.ceil(impact * arg.damage)
			end
		end
	}

	self.Screenshake = {
		intensity = arg.screenshake or 3,
		radius = arg.radius,
		duration = arg.duration
	}
end

---

return e_explosion
