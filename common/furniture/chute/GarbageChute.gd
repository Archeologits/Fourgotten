extends Furniture
class_name GarbageChute

# Member variables
export (String) var chute_message : String = "Chute is open"
export (String) var passage_message : String = "Chute passage is open"

var other_chute : GarbageChute
var chute_opened : bool = false
var passage_opened : bool = false
var chute_count : int = 0
var tools : Array

signal chute_opened()

func _on_chute_opened() -> void:
  # Check if both sides of the chute are opened -> passage opened
  chute_count += 1
  if chute_count == 2:
    passage_opened = true

func _open_chute(number : int) -> void:
  chute_opened = true
  $Sprite.play("open")
  $Audio.play()
  # Emit signal first to determine if chute opened or passage opened
  emit_signal("chute_opened")
  # Tell the player whether the chute is opened of the passage is opened
  Util.swap_message(number, passage_message if passage_opened else chute_message)
