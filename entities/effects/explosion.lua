local class = require("lib.hump.class")
local vector = require("lib.hump.vector")
local util = require("lib.self.util")

---

local table_check = util.table.check

---

local img_particle = love.graphics.newImage("graphics/particle.png")

local e_explosion = class{}

function e_explosion:init(arg)
	assert(table_check(arg, {
		"position",
		"radius",
		"duration"
	}, "Explosion init"))


	self.Color = arg.color or {255, 97, 0}

	self.Position = arg.position:clone()
	self.Lifetime = arg.duration

	self.Blast = {
		radius = arg.radius,
		duration = arg.duration,
		func = function(entity, impact, dir_vec)
			-- Flash entity.
			if entity.Color then entity.ColorPulse = impact end

			-- Apply explosion force.
			if entity.CollisionPhysics and entity.Velocity and not entity.IgnoreExplosion then
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
