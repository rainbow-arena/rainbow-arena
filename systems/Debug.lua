local labelfont = love.graphics.newFont(16)

local floor = math.floor

return {
	systems = {
		{
			name = "DebugDrawEntity",
			requires = {"Position", "Radius"},
			draw = function(entity)
				local pos = entity.Position
				love.graphics.circle("line", floor(pos.x), floor(pos.y), entity.Radius, 20)

				if entity.Name then
					local w = labelfont:getWidth(entity.Name)
					local h = labelfont:getHeight()
					love.graphics.setFont(labelfont)
					love.graphics.print(entity.Name, floor(pos.x - w/2), floor(pos.y - h/2))
				end
			end
		}
	}
}
