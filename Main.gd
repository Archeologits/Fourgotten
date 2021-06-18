extends Node2D

# Member variables
var players = []

onready var popup : PopupDialog = $HUD/Popup
onready var black_screen : BlackScreen = $BlackScreen
export var ROOMS = 4
export var PLAYERS = 3
export var NUMBER_OF_SHAKES = 3
export var SHAKE_INTENSITY = 10
export var SHAKE_BREAK = 1
export var SHAKE_TIME = 0.5

var rooms_rects = []
var active_player = -1
var room : int = -1
var last_room : int = -1

var player3 : Player = preload("res://entities/player3/Player3.tscn").instance()
var player4 : Player = preload("res://entities/player4/Player4.tscn").instance()
var merges : int = 0

var shake_mode = false
onready var clock = 0
var shake_start = 0
var last_shake_end = 0

#===============================================================================
# Switching players
#===============================================================================

func _ready():
  black_screen.unfade()
  Util.current_scene = self
  Util.set_message_stacks(PLAYERS)
  for i in range(PLAYERS):
    players.append(get_node("Player" + str(i)))
  switch_to_player(0)
  for i in range(1, ROOMS + 1):
    rooms_rects.append(get_node("Room" + str(i)).get_rect())
    print(rooms_rects[-1])
  popup.show() # This should be shown when doors are unlocked, etc.

func _input(event : InputEvent) -> void:
  # Handles user input -> switches between players
  for i in range(PLAYERS):
    if active_player != i and i >= merges and event.is_action_pressed("player" + str(i+1)):
      black_screen.fade()
      yield(black_screen.animation_player, "animation_finished")
      switch_to_player(i)
      black_screen.unfade()

func switch_to_player(i):
  for j in range(PLAYERS): # Ensure all other players are false
    players[j].current = false
  players[i].current = true
  active_player = i
  Util.player = i
  Util._update_message()
  Util.update_inventory()

#===============================================================================
# Merging players
#===============================================================================

func _on_merge(player1 : Player, player2 : Player) -> void:
  print("merging", merges, "/", player1.id, "/", player2.id)
  if checkid(player1, player2, "R", "B"):
    merge_into(players[0], players[1], player3)
    Util.swap_base_message("Press 2 for blue/red, press 3 for green!")
  elif checkid(player1, player2, "RB", "G"):
    merge_into(players[2], players[1], player4)
    Util.swap_base_message("All friends are reunited!")    

func checkid(a : Player, b : Player, x : String, y : String) -> bool:
  return (a.id == x and b.id == y) or (a.id == y and b.id == x)

func merge_into(a : Player, b : Player, c : Player):
  # Merge players a and b into player c
  for item in a.tools:
    c.tools.append(item)
  for item in b.tools:
    c.tools.append(item)
  c.position = (a.position + b.position)/2
  remove_child(a)
  remove_child(b)
  add_child(c)
  players[c.number] = c
  switch_to_player(c.number)
  merges += 1

func get_room(pos : Vector2) -> int:
  for i in range(0, ROOMS):
    if rooms_rects[i].has_point(pos):
      last_room = i + 1
      return last_room
  return last_room



func _process(delta : float):
  clock += delta
  #print(active_player)
  room = get_room(players[active_player].position)
  Sounds.playbgm(room)
  #print("Room:" , room, Globals.data[active_player]["room"])
  if Globals.data[active_player]["room"] != room:
    Globals.data[active_player]["room"] = room
    #Util.push_message("Currently in Room #" + str(room))
  var rect = rooms_rects[room - 1]
  var screen_size = get_viewport().size
  var canvas_trans = get_viewport().get_canvas_transform()
  var expand_ratio = \
    min(screen_size.x / rect.size.x, \
        screen_size.y / rect.size.y)
  canvas_trans.x.x = expand_ratio
  canvas_trans.y.y = expand_ratio
  canvas_trans.origin = -rect.position * expand_ratio
  
  if shake_mode:
    if clock - shake_start <= SHAKE_TIME:
      var angle = (clock - shake_start) / SHAKE_TIME * NUMBER_OF_SHAKES * 2 * PI
      canvas_trans.origin += SHAKE_INTENSITY * sin(angle) * Vector2.RIGHT
    else:
      shake_mode = false
  get_viewport().set_canvas_transform(canvas_trans)

func screen_shake() -> bool:
  if clock - shake_start > SHAKE_BREAK + SHAKE_TIME:
    shake_mode = true
    shake_start = clock
    return true
  else:
    return false
  

