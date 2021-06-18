extends Item

# Member variables
onready var destination : Position2D = get_node("../RedKeyDestination")
var red_key_sent : bool = false

func activate() -> void:
  $Collision.disabled = false
  $Light.enabled = true

func interact(body : Player) -> void:
  if !red_key_sent and body.tools.has("Red key"):
    # Blue throws red key to Red study room
    Util.swap_message(body.number, "Threw red key through roof!")
    body.erase_tool("Red key")
    position = destination.position
    $Sprite.visible = true
    $Light.enabled = false
    red_key_sent = true
    # Change the message (used by Item when red player enters collision)
    message = "Press 'E' to pick up red key"
  elif red_key_sent:
    # Red picks up the key from study room
    Util.swap_message(body.number, collected)
    body.collect_tool("Red key")
    item_collected = true
    $Sprite.visible = false
  else:
    Util.swap_message(body.number, "...")
    Util.shake()
