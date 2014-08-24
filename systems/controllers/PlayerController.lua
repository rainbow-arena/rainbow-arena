local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local clamp = util.math.clamp

return {
	systems = {
		{
			name = "PlayerController",
			requires = {"Position", "Player"},
			update = function(player, world, dt)
				local mx, my = love.mouse.getPosition()
				local psx, psy = world.camera:cameraCoords(player.Position.x, player.Position.y)
				player.Rotation = math.atan2(my - psy, mx - psx)

				---

				local lkd = love.keyboard.isDown
				local k_up = lkd("up")
				local k_down = lkd("down")
				local k_left = lkd("left")
				local k_right = lkd("right")

				local accel = player.MoveAcceleration
				player.InputAcceleration = player.InputAcceleration or vector.new(0, 0)

				if k_left and not k_right then
					player.InputAcceleration.x = -accel
				elseif k_right and not k_left then
					player.InputAcceleration.x = accel
				else
					player.InputAcceleration.x = 0
				end

				if k_up and not k_down then
					player.InputAcceleration.y = -accel
				elseif k_down and not k_up then
					player.InputAcceleration.y = accel
				else
					player.InputAcceleration.y = 0
				end

				---

				player.Firing = love.mouse.isDown("l")
			end
		}
	},

	events = {

	}
}
