extends Node2D

# Member variables
export var room_count : int = 4
export var player_count : int = 3
export var number_of_shakes = 3
export var shake_intensity = 10
export var shake_break = 1
export var shake_time = 0.5

#onready var popup : PopupDialog = $HUD/Popup
onready var black_screen : BlackScreen = $BlackScreen
onready var canvas_trans := get_viewport().get_canvas_transform()

var player3 : Player = preload("res://entities/player3/Player3.tscn").instance()
var player4 : Player = preload("res://entities/player4/Player4.tscn").instance()

var players : Array = []
var rooms : Array = []
var current_player : int = -1
var current_room : int = -1
var previous_room : int = -1
var merges : int = 0

var shake_mode : bool = false
var shake_start : float = 0
var clock : float = 0

#===============================================================================
# Switching players
#===============================================================================

func _ready() -> void:
  for i in range(player_count):
    players.append(get_node("Player" + str(i)))
  for i in range(room_count):
    rooms.append(get_node("Room" + str(i)).get_rect())

  Util.game = self
  Util.main = get_parent()
  Util.hud = get_parent().get_node("HUD")  
  Util.label = Util.main.get_node("HUD/Popup/Label")
  Util.main.get_node("HUD/Popup").show()
  Util.set_message_stacks(player_count)
  black_screen.unfade()
  switch_to_player(0)

func _input(event : InputEvent) -> void:
  # Handles user input -> switches between players
  for i in range(player_count):
    if current_player != i and i >= merges and event.is_action_pressed("player" + str(i+1)):
      black_screen.fade()
      yield(black_screen.animation_player, "animation_finished")
      switch_to_player(i)
      black_screen.unfade()

func switch_to_player(i : int) -> void:
  for j in range(player_count): # Ensure all other players are false
    players[j].current = false
  if i == -1: # Used by end-screen to "incapacitate" all players
    return
  players[i].current = true
  current_player = i
  Util.player = i
  Util._update_message()
  Util.update_inventory()

#===============================================================================
# Merging players
#===============================================================================

func _on_merge(player1 : Player, player2 : Player) -> void:
  if checkid(player1, player2, "R", "B"):
    Util.swap_base_message("Press 2 for blue/red, press 3 for green!")
    merge_into(players[0], players[1], player3)
  elif checkid(player1, player2, "RB", "G"):
    Util.swap_base_message("All friends are reunited!")    
    merge_into(players[2], players[1], player4)

func checkid(a : Player, b : Player, x : String, y : String) -> bool:
  return (a.id == x and b.id == y) or (a.id == y and b.id == x)

func merge_into(a : Player, b : Player, c : Player):
  # Merge players a and b into player c
  for item in a.tools:
    c.tools.append(item)
  for item in b.tools:
    c.tools.append(item)
  c.position = (a.position + b.position)/2
  call_deferred("remove_child", a)
  call_deferred("remove_child", b)
  call_deferred("add_child", c)
  players[c.number] = c
  switch_to_player(c.number)
  merges += 1

#===============================================================================
# Switching rooms
#===============================================================================

func _process(delta : float):
  clock += delta
  current_room = get_room(players[current_player].position)
  # Change viewport and background music
  if current_room != previous_room:
    previous_room = current_room
    switch_to_room(current_room)
    Sounds.playbgm(current_room)
#    $CanvasModulate.visible = current_room == 1
  if shake_mode:
    if clock - shake_start <= shake_time:
      var angle = (clock - shake_start) / shake_time * number_of_shakes * 2 * PI
      canvas_trans.origin += shake_intensity * sin(angle) * Vector2.RIGHT
      get_viewport().set_canvas_transform(canvas_trans)
    else:
      shake_mode = false

func get_room(pos : Vector2) -> int:
  for i in range(room_count):
    if rooms[i].has_point(pos):
      return i
  return previous_room

func switch_to_room(i : int) -> void:
  var screen_size = get_viewport().size
  var expand_ratio = \
    min(screen_size.x / rooms[i].size.x, \
        screen_size.y / rooms[i].size.y)
  canvas_trans.x.x = expand_ratio
  canvas_trans.y.y = expand_ratio
  canvas_trans.origin = -rooms[i].position * expand_ratio
  get_viewport().set_canvas_transform(canvas_trans)

func screen_shake() -> void:
  if clock - shake_start > shake_break + shake_time:
    shake_mode = true
    shake_start = clock
