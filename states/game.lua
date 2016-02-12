--- Require ---
local vector = require("lib.hump.vector")

local circle = require("util.circle")
--- ==== ---


--- Classes ---
local World = require("World")
--- ==== ---


--- Gamestate definition ---
local Game = {}
--- ==== ---


--- Gamestate functions ---
local function spawn_test_entities(world)
	world:add_entity{
		Position = vector.new(1280, 720/2),
		Radius = 30,

		Velocity = vector.new(-400, 1),
		Mass = circle.area(30),

		Color = {0, 0, 255},
		AimAngle = 0,

		MaxHealth = 30,
		Health = 20
	}

	world:add_entity{
		Position = vector.new(0, 720/2),
		Radius = 30,

		Velocity = vector.new(400, 0),
		Mass = circle.area(30),

		Color = {255, 0, 0},
		AimAngle = 0,

		MaxHealth = 30,
		Health = 20
	}
end


-- Entering and leaving ---
function Game:init()
	self.world = World()

	self.world.DEBUG = true
	self.world.speed = 0.25

	---

	spawn_test_entities(self.world)
end

function Game:enter(prev, ...)

end

function Game:leave()

end
-- ==== --


-- Updating ---
function Game:update(dt)
	self.world:update(dt)
end

function Game:draw()
	self.world:draw()
end
-- ==== --


-- Input --
function Game:keypressed(key)

end

function Game:mousepressed(x, y, b)


end
-- ==== --
--- ==== ---


return Game

