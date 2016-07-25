--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")
--- ==== ---


--- System ---
local sys_Weapon = Class(tiny.processingSystem())
sys_Weapon.filter = tiny.requireAll("Weapon", "AimAngle")
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Weapon:process(e, dt)
	local world = self.world.world

	local weapon = e.Weapon

	if e.Firing then
		if not e.is_firing then
			e.is_firing = true
			weapon.isFiring = true
			weapon:fire_begin(world, e)
		else
			weapon:firing(world, e, dt)
		end
	else -- if not e.Firing then
		if e.is_firing then
			e.is_firing = false
			weapon.isFiring = false
			weapon:fire_end(world, e)
		end
	end

	weapon:update(world, e, dt)

	---

	if e.Player then
		-- Temporarily disable the camera so we can draw directly on the screen.
		world.camera:detach()

		-- Draw reticle.
		local mx, my = love.mouse.getPosition()
		love.graphics.push()
		love.graphics.setColor(255, 255, 255)
		love.graphics.translate(mx, my)
		weapon:draw_reticle()
		love.graphics.pop()

		world.camera:attach()
	end
end
--- ==== ---

return sys_Weapon
