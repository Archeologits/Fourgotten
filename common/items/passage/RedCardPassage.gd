extends Item

# Member variables
onready var destination : Position2D = get_node("../RedKeyDestination")
var key_sent : bool = false

func activate() -> void:
  $Collision.disabled = false
  $Light.enabled = true

func interact(body : Player) -> void:
  if !key_sent and body.tools.has(tool_name):
    # Blue throws red key to Red study room
    Util.swap_message(body.number, "Threw red key through roof!")
    body.erase_tool(tool_name)
    position = destination.position
    $Sprite.visible = true
    $Light.enabled = false
    $Audio.play()
    key_sent = true
    # Change the message (used by Item when red player enters collision)
    message = "Press 'E' to pick up red key"
  elif key_sent:
    # Red picks up the key from study room
    Util.swap_message(body.number, collected)
    body.collect_tool(tool_name)
    item_collected = true
    $Sprite.visible = false
  else:
    Util.swap_message(body.number, "...")
    Util.shake()
