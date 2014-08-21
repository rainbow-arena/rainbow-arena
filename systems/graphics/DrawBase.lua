local floor = math.floor

return {
	systems = {
		{
			name = "DrawImage",
			requires = {"Position", "Image"},
			draw = function(entity)
				local img = entity.Image

				love.graphics.draw(
					img,
					floor(entity.Position.x - img:getWidth()/2),
					floor(entity.Position.y - img:getHeight()/2)
				)
			end
		}
	}
}
