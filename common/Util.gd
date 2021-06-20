extends Node

var game = null
var main = null
var hud = null
var label = null
var player : int
var messages : Dictionary # Should this be an array of arrays?
var inventory : Dictionary # We store only the current player inventory

func shake():
  game.screen_shake()

func get_player():
  return game.players[player]

#===============================================================================
# Popup messages
#===============================================================================

func set_message_stacks(player_count : int) -> void:
#  game.get_node("HUD/Players/Viewport")
#  var camera : Camera2D= game.players[0].get_node("Camera")
#  var vp = game.get_node("HUD/Players/ViewportContainer/Viewport")
##  print(vp.find_world_2d())
#  var cam = game.get_node("HUD/Players/ViewportContainer/Viewport/Camera")
#  cam.target = game.players[0]
#  cam.current = true
#  vp.world_2d = get_viewport().world_2d
#  print(get_viewport().size.x)
#  print(vp.world_2d)
#  print(cam.target)
#  var sprite := TextureRect.new()
#  sprite.texture = vp.get_texture()
#  game.get_node("HUD/Players").add_child(sprite)

  # We are using arrays as stacks
  for i in range(player_count):
    messages[i] = ["Press 1 for blue, 2 for red, 3 for green"]

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
  for player_number in messages.keys():
    messages[player_number][0] = new_message

func _update_message() -> void:
  if !messages[player].empty():
    label.text = messages[player].back()

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
  hud.get_node("Inventory").add_child(sprite)
  inventory[tool_name] = sprite

func erase_tool(tool_name : String) -> void:
  if inventory.has(tool_name):
    var sprite : TextureRect = inventory.get(tool_name)
    hud.get_node("Inventory").remove_child(sprite)
    inventory.erase(tool_name)
    sprite.queue_free()

func update_inventory() -> void:
  inventory.clear()
  for sprite in hud.get_node("Inventory").get_children():
    hud.get_node("Inventory").remove_child(sprite)
    sprite.queue_free()
  for tool_name in Util.get_player().tools:
    push_tool(tool_name)