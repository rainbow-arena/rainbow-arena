local vector = require("lib.hump.vector")

---

local wepm_projectile = {}

---

function wepm_projectile.init(self, projectile, shotvel, spread)
	self.projectile = assert(projectile, "Projectile weapon requires projectile!")
	self.shotvel = assert(shotvel, "Projectile weapon requires shotvel!")
	self.spread = spread
end

function wepm_projectile.fire_from(self, host, world, pos, vel)
	local proj = world:spawn_entity(self.projectile)

	proj.Position = pos:clone()
	proj.Velocity = vel:clone()
	proj.CollisionExcludeEntities = {host}
	proj.Team = host.Team

	return proj
end

function wepm_projectile.fire(self, host, world)
	local h_pos = host.Position
	local h_rot = host.Rotation
	local h_rad = host.Radius

	local dir_vec = vector.new(math.cos(h_rot), math.sin(h_rot))

	if self.spread then
		local amp = love.math.random() - 0.5
		dir_vec:rotate_inplace(amp * self.spread) -- Apply spread.
	end

	local pointer_vec = dir_vec * h_rad
	local pos = h_pos + pointer_vec

	return wepm_projectile.fire_from(self, host, world, pos, self.shotvel * dir_vec)
end

---

return wepm_projectile
