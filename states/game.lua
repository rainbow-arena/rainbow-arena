local game = {}

local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local worldutil = require("util.world")
local circleutil = require("util.circle")
local colorutil = require("util.color")

---

local colliding = circleutil.colliding
local nelem = util.table.nelem

---

local world

function game:init()
	world = worldutil.new()
	world:load_system_dir("systems")
end

-- https://stackoverflow.com/questions/667034/simple-physics-based-movement
local function calculate_drag_accel(max_speed, accel_time)
	local drag = 5/accel_time -- drag = 5/t_max
	local accel = max_speed * drag -- acc = v_max * drag
	return drag, accel
end

function game:enter(previous, arg)
	arg = arg or {}

	world:clear_entities()

	world.w, world.h = arg.w or 1000, arg.h or 1000

	local c_radius = arg.combatant_radius or 30

	local c_drag, c_accel = calculate_drag_accel(arg.max_speed or 800, arg.max_speed_time or 5)


end

function game:update(dt)
	world:update(dt)
end

function game:draw()
	world:draw(
		function(self) -- Draws "affected" by the camera.
			-- Arena boundaries.
			love.graphics.line(0,0, 0,self.h)
			love.graphics.line(0,self.h, self.w,self.h)
			love.graphics.line(self.w,self.h, self.w,0)
			love.graphics.line(self.w,0, 0,0)
		end,

		function(self) -- Camera-independent draws.
			love.graphics.setColor(255, 255, 255)
			love.graphics.print("Speed multiplier: " .. self.speed, 10, 10)
			love.graphics.print(
				"Entities: " .. nelem(self.entities),
				10, 10 + love.graphics.getFont():getHeight()
			)
		end
	)
end


function game:keypressed(key, isrepeat)
	world:emit_event("KeyPressed", key, isrepeat)
end

function game:keyreleased(key)
	world:emit_event("KeyReleased", key)
end

function game:mousepressed(x, y, b)
	world:emit_event("MousePressed", x, y, b)
end

function game:mousereleased(x, y, b)
	world:emit_event("MouseReleased", x, y, b)
end

return game
