local vector = require("lib.hump.vector")
local util = require("lib.self.util")

---

local math_atan2 = math.atan2

---

return {
	systems = {
		{
			name = "PlayerController",
			requires = {"Position", "Player"},
			update = function(entity, world, dt)
				local mx, my = love.mouse.getPosition()
				local psx, psy = world.camera:cameraCoords(entity.Position.x, entity.Position.y)

				entity.RotationTarget = math_atan2(my - psy, mx - psx)

				---

				local lkd = love.keyboard.isDown
				local k_up = lkd("up")
				local k_down = lkd("down")
				local k_left = lkd("left")
				local k_right = lkd("right")

				local accel = entity.MoveAcceleration
				entity.InputAcceleration = entity.InputAcceleration or vector.new(0, 0)

				if k_left and not k_right then
					entity.InputAcceleration.x = -accel
				elseif k_right and not k_left then
					entity.InputAcceleration.x = accel
				else
					entity.InputAcceleration.x = 0
				end

				if k_up and not k_down then
					entity.InputAcceleration.y = -accel
				elseif k_down and not k_up then
					entity.InputAcceleration.y = accel
				else
					entity.InputAcceleration.y = 0
				end

				---

				entity.Firing = love.mouse.isDown("l")
			end
		}
	},

	events = {

	}
}
