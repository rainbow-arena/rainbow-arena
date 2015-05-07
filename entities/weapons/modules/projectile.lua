local wepm_projectile = {}

---

local vector = require("lib.hump.vector")

---

function wepm_projectile.init(self, projtemp, projvel)
	assert(projtemp, "Projectile weapon requires projectile!")

	self._projectile = projtemp
	self._projvel = projvel
end

function wepm_projectile.fire_from(self, world, pos, vel)
	local proj = world:spawn_entity(self._projectile)

	proj.Position = pos:clone()
	proj.Velocity = vel:clone()

	return proj
end

function wepm_projectile.fire(self, host, world)
	local h_pos = host.Position
	local h_rot = host.Rotation
	local h_rad = host.Radius

	local dir_vec = vector.new(math.cos(h_rot), math.sin(h_rot))
	local pointer_vec = dir_vec * h_rad

	local shot_pos_vec = h_pos + dir_vec

	return wepm_projectile.fire_from(self, world, shot_pos_vec, self.projvel * dir_vec)
end

---

return wepm_projectile
