extends CanvasLayer

# Declare member variables here. Examples:
const PLAYER_PATH : String = "Players/HBox/Player%s"
const VIEWPORT_PATH : String = "Players/HBox/Player%s/Container/Viewport"

var game : Node2D           # Reference to the game world
var players : Array         # Array of player containers
var viewports : Array       # Array of player viewports
var cameras : Array         # Array of player cameras
var messages : Array        # Array of player message stacks
var inventory : Dictionary  # Current player's inventory

func start(world : World2D, new_game : Node2D) -> void:
  game = new_game
  $Popup.show()
  set_player_switcher(world, new_game)
  set_message_stacks()
  update_inventory()

#===============================================================================
# Player switcher
#===============================================================================

func set_player_switcher(world : World2D, game : Node2D) -> void:
  for i in range(Globals.player_count):
    players.push_back(get_node(PLAYER_PATH % i))
    viewports.push_back(get_node(VIEWPORT_PATH % i))
    viewports[i].world_2d = world
    cameras.push_back(viewports[i].get_node("CameraX"))
    cameras[i].target = game.players[i]

func merge_players():
  pass
#===============================================================================
# Popup messages
#===============================================================================

func set_message_stacks(player_count : int = Globals.player_count) -> void:
  # We are using arrays as stacks
  for i in range(player_count):
    messages.push_back(["Press 1 for blue, 2 for red, 3 for green"])

func push_message(player_number : int, new_message : String) -> void:
  messages[player_number].push_back(new_message)
#  game.get_node("HUD/PopupSound").play()
  _update_message()

func pop_message(player_number : int) -> void:
  if !messages[player_number].empty():
    messages[player_number].pop_back()
    _update_message()

func swap_message(player_number : int, new_message : String) -> void:
  if !messages[player_number].empty():
    messages[player_number][-1] = new_message
#    game.get_node("HUD/PopupSound").play()
    _update_message()

func swap_base_message(new_message : String) -> void:
  for message in messages:
    message[0] = new_message

func _update_message() -> void:
#  print(Globals.player)
#  print(messages)
  if !messages[Globals.player].empty():
    $Popup/Label.text = messages[Globals.player].back()

#===============================================================================
# Inventory
#===============================================================================

func push_tool(tool_name : String) -> void:
  var loaded = load("res://tool_images/" + tool_name + ".png")
  if loaded == null:
    return
  var image = loaded.get_data()
  image.resize(32, 32)
  var texture := ImageTexture.new()
  texture.create_from_image(image)
  var sprite := TextureRect.new()
  sprite.texture = texture
  $Inventory.add_child(sprite)
  inventory[tool_name] = sprite

func erase_tool(tool_name : String) -> void:
  # inventory stores human-readable tool names and references to the sprites
  if inventory.has(tool_name):
    var sprite : TextureRect = inventory.get(tool_name)
    $Inventory.remove_child(sprite)
    inventory.erase(tool_name)
    sprite.queue_free()

func update_inventory() -> void:
  # We can simply remove all children and clear the inventory when updating
  inventory.clear()
  for sprite in $Inventory.get_children():
    $Inventory.remove_child(sprite)
    sprite.queue_free()
  for tool_name in Util.get_player().tools:
    push_tool(tool_name)


func _on_player0_clicked(event : InputEvent):
  print(":oi")
  if event is InputEventMouseButton:
    print("I've been clicked D:")
  if event.is_action_pressed("left_click"):
    game.switch_to_player(0)


func _input(event : InputEvent) -> void:
  if event is InputEventMouseButton:
    for i in range(Globals.player_count):
      if players[i].get_global_rect().has_point(event.position):
        game.switch_to_player(i)
