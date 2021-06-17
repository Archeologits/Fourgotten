extends CanvasLayer
class_name BlackScreen

# Member variables
onready var animation_player : AnimationPlayer = $BlackScreen/AnimationPlayer

func fade() -> void:
  $BlackScreen.rect_size = get_viewport().size
  animation_player.play("fade")

func unfade() -> void:
  $BlackScreen.rect_size = get_viewport().size  
  animation_player.play_backwards("fade")
