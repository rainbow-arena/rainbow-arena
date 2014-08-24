return {
	systems = {
		{
			name = "CameraController",
			requires = {"Position", "CameraTarget"},
			priority = -1,
			update = function(entity, world, dt)
				world.camera:lookAt(entity.Position.x, entity.Position.y)
			end
		}
	}
}
