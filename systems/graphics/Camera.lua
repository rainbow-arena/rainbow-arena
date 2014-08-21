return {
	systems = {
		{
			name = "CameraController",
			requires = {"Position", "CameraTarget"},
			priority = -1,
			update = function(target, dt, world, camera)
				camera:lookAt(target.Position.x, target.Position.y)
			end
		}
	}
}
