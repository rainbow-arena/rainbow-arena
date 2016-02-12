--- Require ---
local util = require("lib.self.util")
--- ==== ---


--- Classes ---
--- ==== ---


--- Gamestate definition ---
local Game = {}
--- ==== ---


--- Gamestate functions ---
-- Entering and leaving ---
function Game:init()

end

function Game:enter(prev, ...)

end

function Game:leave()

end
-- ==== --


-- Updating ---
function Game:update(dt)

end

function Game:draw()

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

