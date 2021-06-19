extends Camera2D
class_name CameraX

var target = null

func _physics_process(delta):
  if target:
    position = target.position
