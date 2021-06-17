extends Node
class_name Tool

# Member variables
export (String) var tool_name : String = "Tool"

func _ready():
  connect("body_entered", self, "_on_player_entered")

func _on_player_entered(body : Node2D) -> void:
  if body.is_in_group("Players"):
    body.collect_tool(tool_name)
# Uncomment next two lines when audio is added to ALL tools
#    $Audio.play()
#    yield($Audio, "finished")
    queue_free()
