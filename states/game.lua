--- Require ---
--- ==== ---


--- Classes ---
local World = require("World")
--- ==== ---


--- Gamestate definition ---
local Game = {}
--- ==== ---


--- Gamestate functions ---
-- Entering and leaving ---
function Game:init()
	self.world = World()
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

