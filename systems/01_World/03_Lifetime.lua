--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local circle = require("util.circle")
--- ==== ---

--- System ---
local sys_Lifetime = Class(tiny.processingSystem())
sys_Lifetime.filter = tiny.requireAll("Position", "Lifetime")
--- ==== ---

--- Constants ---
--- ==== ---

--- Local functions ---
local function draw_entity_debug_info(e)
   local str_t = {}

   ---

   --str_t[#str_t + 1] = (""):format()

   str_t[#str_t + 1] = ("Lifetime: %.2f"):format(e.Lifetime)

   ---

   local str = table.concat(str_t, "\n")

   local text_w = love.graphics.getFont():getWidth(str)

   local x = e.Position.x - text_w / 2
   local y = e.Position.y + 10

   love.graphics.setColor(1, 1, 1)
   love.graphics.print(str, math.floor(x), math.floor(y))
end
--- ==== ---

--- System functions ---
function sys_Lifetime:process(e, dt)
   local world = self.world.world

   ---

   e.Lifetime = e.Lifetime - dt

   if e.Lifetime < 0 then
      world:remove_entity(e)
   end

   ---

   if world.DEBUG then
      draw_entity_debug_info(e)
   end
end
--- ==== ---

return sys_Lifetime
