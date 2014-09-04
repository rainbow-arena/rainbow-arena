local game = {}

local screenshake = require("lib.self.screenshake")
local util = require("lib.self.util")

local worldutil = require("util.world")
local circleutil = require("util.circle")
local colorutil = require("util.color")

local vector = require("lib.hump.vector")

---

local colliding = circleutil.colliding
local nelem = util.table.nelem

---

local COMBATANT_RADIUS = 30

---

local world

function game:init()
	world = worldutil.new()
	world:load_system_dir("systems")
end

local function generate_position(radius)
	return vector.new(
		love.math.random(radius, world.w - radius),
		love.math.random(radius, world.h - radius)
	)
end

local function find_position(radius, tries)
	for try = 1, tries or 10 do
		local ok = true

		local pos = generate_position(radius)
		for entity in pairs(world:get_entities_with{"Position", "Radius"}) do
			if colliding(pos,radius, entity.Position,entity.Radius) then
				ok = false
				break
			end
		end

		if ok then return pos end
	end
end

-- https://stackoverflow.com/questions/667034/simple-physics-based-movement
local function calculate_drag_accel(max_speed, accel_time)
	local drag = 5/accel_time -- drag = 5/t_max
	local accel = max_speed * drag -- acc = v_max * drag
	return drag, accel
end

function game:enter(previous, arg)
	world:clear_entities()

	world.w, world.h = arg.w or 1000, arg.h or 1000

	local c_drag, c_accel = calculate_drag_accel(arg.max_speed or 800, arg.max_speed_time or 5)


end

function game:update(dt)
	world:update(dt)
end

function game:draw()
	world:draw(function()
		-- Arena boundaries.
		love.graphics.line(0,0, 0,world.h)
		love.graphics.line(0,world.h, world.w,world.h)
		love.graphics.line(world.w,world.h, world.w,0)
		love.graphics.line(world.w,0, 0,0)
	end,

	function()
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("Speed multiplier: " .. world.speed, 10, 10)
		love.graphics.print(
			"Entities: " .. nelem(world.entities),
			10, 10 + love.graphics.getFont():getHeight()
		)
	end)
end


function game:keypressed(key, isrepeat)
	world:emit_event("KeyPressed", key, isrepeat)
end

function game:keyreleased(key)
	world:emit_event("KeyReleased", key)
end

function game:mousepressed(x, y, b)
	if b == "wd" then
		world.speed = world.speed - 0.1
	elseif b == "wu" then
		world.speed = world.speed + 0.1
	end

	if b == "r" then
		world:spawn_entity(require("entities.effects.explosion"){
			position = vector.new(world.camera:worldCoords(x, y)),
			force = 2*10^6
		})
	end

	world:emit_event("MousePressed", x, y, b)
end

function game:mousereleased(x, y, b)
	world:emit_event("MouseReleased", x, y, b)
end

return game
