--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")
--- ==== ---


--- System definition ---
local sys_PlayerInput = tiny.processingSystem()
sys_PlayerInput.filter = tiny.requireAll("Mass", "Forces", "MoveForce", "Player")
--- ==== ---


--- Local functions ---
local lkd = love.keyboard.isDown
--- ==== ---


--- System functions ---
function sys_PlayerInput:process(e, dt)
	local world = self.world.world

	-- Movement
	local input_force = e.MoveForce

	local input_x, input_y = 0, 0

	if lkd("up") then
		input_y = input_y - 1
	end

	if lkd("down") then
		input_y = input_y + 1
	end

	if lkd("left") then
		input_x = input_x - 1
	end

	if lkd("right") then
		input_x = input_x + 1
	end

	e.Forces[#e.Forces + 1] = (input_force * vector.new(input_x, input_y):normalized())


	-- Aiming
	local mx, my = love.mouse.getPosition()
	local psx, psy = e.Position.x, e.Position.y

	e.DesiredAimAngle = math.atan2(my - psy, mx - psx)
end
--- ==== ---

return Class(sys_PlayerInput)
