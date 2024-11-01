-- Rainbow Arena, a game by Mirrexagon.
--
-- The code is under the 0BSD license (see `LICENSE`).
--
-- Sounds, music, and graphics are under the Creative Commons CC-BY 4.0 license (see `LICENSE-CC-BY-4.0`).
-- - Sound effects made with Bfxr (http://www.bfxr.net) and Audacity (http://www.audacityteam.org).
-- - Music made by me; see https://mirx.dev/music
--
-- Note that parts NOT made by me remain the property of their respective authors; these parts include:
-- - lib/hump is HUMP by vrld (https://github.com/vrld/hump)
-- - lib/tiny.lua is tiny-ecs by bakpakin (https://github.com/bakpakin/tiny-ecs)

gs = require "lib.hump.gamestate"

love.load = ->
    gs.registerEvents!
    gs.switch (require "states.game")

