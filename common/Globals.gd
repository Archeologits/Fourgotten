extends Node

# Member variables
var room_count : int = 4
var player_count : int = 3
var player : int = -1

var data : Dictionary = {}

func _ready():
  for i in range(player_count):
    data[i] = {}
    data[i]["room"] = -1

  for i in range(room_count):
    data["Room%s" % i] = {}
