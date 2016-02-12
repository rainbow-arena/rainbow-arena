--- Require ---
local vector = require("lib.hump.vector")
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
		Position = vector.new(400, 400),
		Radius = 30,
		Color = {255, 255, 255},
		AimAngle = 0
	}
end


-- Entering and leaving ---
function Game:init()
	self.world = World()

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

