--[[
    Rainbow Arena, a game by Mirrexagon.

    ---

    All parts of this project made by me are released into the public domain
    via CC0 (https://creativecommons.org/publicdomain/zero/1.0). See COPYING
    for the license text.

    Sound effects made by me with Bfxr (http://www.bfxr.net) and Audacity
    (http://www.audacityteam.org).

    Music made by me; see http://www.mirrexagon.com/music

    ---

    Note that parts NOT made by me remain the property of their respective
    authors; these parts include:
        - lib/hump is HUMP by vrld (https://github.com/vrld/hump)
        - lib/tiny.lua is tiny-ecs by bakpakin (https://github.com/bakpakin/tiny-ecs)
]]


--- Require ---
local gs = require("lib.hump.gamestate")
--- ==== ---


function love.load()
    gs.registerEvents()
    gs.switch(require("states.game"))
end
