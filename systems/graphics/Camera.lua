return {
	systems = {
		{
			name = "CameraController",
			priority = -1,
			update = function(_, world, dt)
				local entity = world.camera_target or {}
				if entity.Position then
					world.camera:lookAt(entity.Position.x, entity.Position.y)
				end
			end
		}
	}
}
