return {
	systems = {
		{
			name = "DrawCombatant",
			requires = {"Position", "Radius", "Color"},
			draw = function(entity)
				local pos = entity.Position
				local radius = entity.Radius
				local color = entity.Color

				if entity.ColorIntensity then
					local v = entity.ColorIntensity
					love.graphics.setColor(color[1] * v, color[2] * v, color[3] * v)
				else
					love.graphics.setColor(color[1]/3, color[2]/3, color[3]/3)
				end
				love.graphics.circle("fill", pos.x, pos.y, radius, 20)

				love.graphics.setColor(color)
				love.graphics.circle("line", pos.x, pos.y, radius, 20)
			end
		},

		{
			name = "RestoreCombatantColor",
			requires = {"ColorIntensity"},
			update = function(entity, world, dt)
				local rate = entity.ColorRate or 1

				if entity.ColorIntensity < 0.33 then
					entity.ColorIntensity = entity.ColorIntensity + rate*dt
				elseif entity.ColorIntensity > 0.33 then
					entity.ColorIntensity = entity.ColorIntensity - rate*dt
				end
			end
		}
	},

	events = {
		{ -- Entity color flashes.
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				entity.ColorIntensity = 0.75
			end
		},
		{
			event = "PhysicsCollision",
			func = function(world, ent1, ent2, mtv)
				ent1.ColorIntensity = 0.75
				ent2.ColorIntensity = 0.75
			end
		}
	}
}
