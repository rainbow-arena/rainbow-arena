local util = require("lib.self.util")

local clamp = util.math.clamp

return {
	systems = {
		{
			name = "PlayerController",
			requires = {"Position", "Player"},
			update = function(player, world, dt, camera)
				local mx, my = love.mouse.getPosition()
				local psx, psy = camera:cameraCoords(player.Position.x, player.Position.y)
				player.Rotation = math.atan2(my - psy, mx - psx)

				---

				local lkd = love.keyboard.isDown
				local k_up = lkd("up")
				local k_down = lkd("down")
				local k_left = lkd("left")
				local k_right = lkd("right")

				local acceleration = player.MoveAcceleration

				if k_left and not k_right then
					player.InputAcceleration.x = -acceleration
				elseif k_right and not k_left then
					player.InputAcceleration.x = acceleration
				else
					player.InputAcceleration.x = 0
				end

				if k_up and not k_down then
					player.InputAcceleration.y = -acceleration
				elseif k_down and not k_up then
					player.InputAcceleration.y = acceleration
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
