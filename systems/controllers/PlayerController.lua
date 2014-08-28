local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local range = util.math.range
local clamp = util.math.clamp
local sign = util.math.sign
local sin, cos, atan2 = math.sin, math.cos, math.atan2
local pi = math.pi

return {
	systems = {
		{
			name = "PlayerController",
			requires = {"Position", "Player"},
			update = function(player, world, dt)
				local current_angle = player.Rotation or 0

				local mx, my = love.mouse.getPosition()
				local psx, psy = world.camera:cameraCoords(player.Position.x, player.Position.y)
				local target_angle = atan2(my - psy, mx - psx)

				-- TODO: Make rotating limited by RotationSpeed. Some weapons change this while firing.
				player.Rotation = target_angle

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
		},

		{
			name = "DebugDrawPlayerRotation",
			requires = {"Player", "Position", "Rotation"},
			priority = -100,
			draw = function(entity)
				local len = 40
				local sx, sy = entity.Position:unpack()
				local ex, ey = sx + len*cos(entity.Rotation), sy + len*sin(entity.Rotation)
				love.graphics.setColor(255, 255, 255)
				love.graphics.line(sx,sy, ex,ey)
			end
		}
	},

	events = {

	}
}
