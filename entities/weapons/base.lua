local class = require("lib.hump.class")

---

local w_base = class{}

---

function w_base:init(arg)
	self.max_heat = arg.max_heat or 3
	self.shake_radius = arg.shake_radius or 100

	self.heat = 0
end

function w_base:start(host, world, pos, dir)
	self.effect_ent = world:spawn_entity{
		Position = host.Position:clone()
	}
end

---


function w_base:set_screenshake(intensity, duration)
	if self.effect_ent then
		self.effect_ent.Screenshake = {
			intensity = intensity or 1,
			radius = self.shake_radius,
			duration = duration
		}
	end
end

function w_base:set_sound(source, pitch)
	if self.effect_ent then
		self.effect_ent.Sound = {
			source = source,
			pitch = pitch
		}
	end
end

function w_base:set_sound_pitch(pitch)
	if self.effect_ent and self.effect_ent.Sound then
		self.effect_ent.Sound.pitch = pitch
	end
end

---

function w_base:firing(dt, host, world, pos, dir)
	self.effect_ent.Position = host.Position:clone()
end

function w_base:cease(host, world)
	world:destroy_entity(self.effect_ent)
end

function w_base:update(dt, host, world)

end

---

return w_base
