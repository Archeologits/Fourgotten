extends Node2D

# Member variables
var players = []

onready var popup : PopupDialog = $Popup/Popup
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

var player4
var player5
var merges

func merge_into(a : Player, b : Player, c:Player):
  for item in a.tools:
    c.tools.append(item)
  for item in b.tools:
    c.tools.append(item)
  c.position = b.position

func checkid(a, b, x, y):
  return (a.id == x and b.id == y) or (a.id == y and b.id == x)

func _on_merge(player1 : Player, player2 : Player) -> void:
  print("merging", merges, "/", player1.id, "/", player2.id)
  if checkid(player1, player2, "R", "B"):
    merge_into(players[0], players[1], player4)

    remove_child(players[0])
    remove_child(players[1])
    
    players[1] = player4
    add_child(player4)
    merges += 1
    set_player(2)
    # SET BASE MESSAGE
    return
  elif checkid(player1, player2, "RB", "G"):
    print("ok")
    merge_into(players[2], players[1], player5)
    
    remove_child(players[1])
    remove_child(players[2])
    
    players[2] = player5
    add_child(player5)
    merges += 1

    # SET BASE MESSAGE
    set_player(3)

func _ready():
  player4 = preload("res://entities/player4/Player4.tscn").instance()
  player5 = preload("res://entities/player5/Player5.tscn").instance()
  
  merges = 0
  player4.id = "RB"
  player5.id = "RGB"
  black_screen.unfade()
  Util.current_scene = self
  Util.set_message_stacks(PLAYERS)
  for i in range(1, PLAYERS + 1):
    players.append(get_node("Player" + str(i)))
  players[0].id = "B"
  players[1].id = "R"
  players[2].id = "G"
  set_player(1)
  
  for i in range(1, ROOMS + 1):
    rooms_rects.append(get_node("Room" + str(i)).get_rect())
    print(rooms_rects[-1])
  popup.show() # This should be shown when doors are unlocked, etc.

var last_room

func get_room(pos):
  #print("Position:", pos)
  for i in range(0, ROOMS):
    if rooms_rects[i].has_point(pos):
      last_room = i + 1
      return last_room
  return last_room

func set_player(i):
  for j in range(0, PLAYERS):
    players[j].current = false
  players[i - 1].current = true
  active_player = i
  Util.player = i
  Util._update_message()

func set_active_player():
  for i in range(0, PLAYERS):
    if players[i].current:
      active_player = i + 1
      return

var shake_mode = false
onready var clock = 0
var shake_start = 0
var last_shake_end = 0

func _process(_delta):
  clock += _delta
  #print(active_player)
  room = get_room(players[active_player-1].position)
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

func screen_shake():
  if clock - shake_start > SHAKE_BREAK + SHAKE_TIME:
    shake_mode = true
    shake_start = clock
    return true
  else:
    return false
  
func _input(event : InputEvent) -> void:
  # Please don't judge this code too harshly (or refactor if deemed necessary)
  # Refactoring done -- sugar, functionality should still be the same
  if event.is_action_pressed("ui_accept"):
    Util.shake()
    return
  for i in range(1, PLAYERS + 1):
    if event.is_action_pressed("player" + str(i)) and active_player != i and i >= merges + 1:
      black_screen.fade()
      yield(black_screen.animation_player, "animation_finished")
      set_player(i)
      black_screen.unfade()
