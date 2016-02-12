--- Require ---
local vector = require("lib.hump.vector")

local circle = require("util.circle")
--- ==== ---


--- Classes ---
local World = require("World")

local ent_Combatant = require("entities.Combatant")
--- ==== ---


--- Gamestate definition ---
local Game = {}
--- ==== ---


--- Gamestate functions ---
local function spawn_test_entities(world)
	local window_w, window_h = love.graphics.getDimensions()

	---

	world:add_entity{
		Position = vector.new(100, 100),
		Radius = 30,
		Color = {255, 255, 255},
		AimAngle = 4
	}

	world:add_entity(ent_Combatant{
		Position = vector.new(200, window_h/2),
		Force = vector.new(1000000, 0)
	})

	world:add_entity(ent_Combatant{
		Position = vector.new(window_w - 200, window_h/2),
		Force = vector.new(-1000000, 0)
	})
end


-- Entering and leaving ---
function Game:init()
	self.world = World()

	self.world.DEBUG = true
	self.world.speed = 1

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

