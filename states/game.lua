local game = {}

local ces = require("lib.self.ces")
local camera = require("lib.hump.camera")
local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local circle = require("logic.circle")

local weapons = require("content.weapons")

local world
local arena_w, arena_h
local player
local main_camera = camera.new()

local game_speed = 1

local PLAYER_RADIUS = 30

local function loadSystems(dir)
	for _, item in ipairs(love.filesystem.getDirectoryItems(dir)) do
		if love.filesystem.isDirectory(dir .. "/" .. item) then
			loadSystems(dir .. "/" .. item)
		else
			local t = dofile(dir .. "/" .. item)

			if t.systems then
				for _, system in ipairs(t.systems) do
					world:addSystem(system)
				end
			end
			if t.events then
				for _, eventitem in pairs(t.events) do
					world:registerEvent(eventitem.event, eventitem.func)
				end
			end
		end
	end
end

function game:init()
	world = ces.new()
	loadSystems("systems")
end

local function generate_position(radius)
	return vector.new(
		love.math.random(radius, arena_w - radius),
		love.math.random(radius, arena_h - radius)
	)
end

local function find_position(radius, tries)
	for try = 1, tries or 10 do
		local ok = true

		local pos = generate_position(radius)
		for entity in pairs(world:getEntitiesWith{"Position", "Radius"}) do
			if circle.colliding(pos,radius, entity.Position,entity.Radius) then
				ok = false
				break
			end
		end

		if ok then return pos end
	end
end

function game:enter(previous, w, h, nbots)
	world:clearEntities()

	arena_w, arena_h = w or 1000, h or 1000

	player = world:spawnEntity{
		Name = "Player",

		Radius = PLAYER_RADIUS,
		Position = find_position(PLAYER_RADIUS),
		Velocity = vector.new(0, 0),
		Acceleration = vector.new(0, 0),

		InputAcceleration = vector.new(0, 0),
		RecoilAcceleration = vector.new(0, 0),

		Drag = 5/5, -- drag = 5/t_max
		MoveAcceleration = 1000 * 5/5, -- acc = v_max * drag

		CollisionPhysics = true,

		Weapon = weapons.pistol(1000, 0.3, 1),

		Player = true,
		CameraTarget = true
	}

	-- Place bots.
	for n = 1, nbots or 10 do
		local radius = love.math.random(5, 30)
		world:spawnEntity{
			Name = "Ball " .. n,

			Radius = radius,
			Position = find_position(radius),
			Velocity = vector.new(0, 0),
			Acceleration = vector.new(0, 0),

			Drag = 5/5, -- drag = 5/t_max
			MoveAcceleration = 600 * 5/5, -- acc = v_max * drag

			CollisionPhysics = true
		}
	end
end

function game:update(dt)
	game_speed = util.math.clamp(0.1, game_speed, 7)

	local adjdt = dt * game_speed
	world:runSystems("update", adjdt, main_camera, arena_w, arena_h)
end

function game:draw()
	main_camera:attach()

	-- Arena boundaries.
	love.graphics.line(0,0, 0,arena_h)
	love.graphics.line(0,arena_h, arena_w,arena_h)
	love.graphics.line(arena_w,arena_h, arena_w,0)
	love.graphics.line(arena_w,0, 0,0)

	world:runSystems("draw", main_camera)
	main_camera:detach()

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Speed multiplier: " .. game_speed, 10, 10)
	love.graphics.print(
		"Entities: " .. util.table.nelem(world.entities),
		10, 10 + love.graphics.getFont():getHeight()
	)
end


function game:keypressed(key, isrepeat)
	world:emitEvent("KeyPressed", key, isrepeat)
end

function game:keyreleased(key)
	world:emitEvent("KeyReleased", key)
end

function game:mousepressed(x, y, b)
	if b == "wd" then
		game_speed = game_speed - 0.1
	elseif b == "wu" then
		game_speed = game_speed + 0.1
	end

	world:emitEvent("MousePressed", x, y, b)
end

function game:mousereleased(x, y, b)
	world:emitEvent("MouseReleased", x, y, b)
end

return game
